$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot

$factsPath = Join-Path $root 'data\listing_facts.csv'
$decisionsPath = Join-Path $root 'data\listing_decisions.csv'
$scoresPath = Join-Path $root 'data\listing_scores_long.csv'
$sourcesPath = Join-Path $root 'data\source_registry.csv'
$humanOutputPath = Join-Path $root 'data\listing_output_human.csv'

$facts = Import-Csv $factsPath
$decisions = Import-Csv $decisionsPath
$scores = Import-Csv $scoresPath
$sources = Import-Csv $sourcesPath
$humanOutput = @()
if (Test-Path $humanOutputPath) {
  $humanOutput = Import-Csv $humanOutputPath
}

$allowedFactStates = @(
  'phase2_extracted',
  'phase3_hard_filter_reviewed',
  'phase6_scored_provisional',
  'phase6_scored_final',
  'phase6_scored_failed'
)

$allowedDecisionStates = $allowedFactStates
$allowedHardFilterStatuses = @('extracted', 'hard_filter_tbd', 'hard_filter_failed')
$allowedRankableStatuses = @(
  'rankable',
  'review_only_hard_filter_tbd',
  'not_rankable_extraction_only',
  'not_rankable_hard_filter_failed'
)

$script:results = @()

function Add-Result {
  param(
    [string]$Name,
    [bool]$Passed,
    [string]$Details
  )
  $script:results += [pscustomobject]@{
    Check = $Name
    Status = if ($Passed) { 'PASS' } else { 'FAIL' }
    Details = $Details
  }
}

function Missing-MetadataCount {
  param($rows, [string[]]$fields)
  return ($rows | Where-Object {
    foreach ($field in $fields) {
      if ([string]::IsNullOrWhiteSpace($_.$field)) { return $true }
    }
    return $false
  }).Count
}

function Parse-Number {
  param([string]$Value)
  if ([string]::IsNullOrWhiteSpace($Value)) { return $null }
  $number = 0.0
  if ([double]::TryParse($Value, [ref]$number)) { return $number }
  return $null
}

$factIds = $facts | Select-Object -ExpandProperty listing_id
$decisionIds = $decisions | Select-Object -ExpandProperty listing_id
$scoreIds = $scores | Select-Object -ExpandProperty listing_id

Add-Result 'facts_decisions_same_row_count' ($facts.Count -eq $decisions.Count) "facts=$($facts.Count), decisions=$($decisions.Count)"
Add-Result 'facts_decisions_same_unique_ids' ((($factIds | Sort-Object -Unique).Count) -eq (($decisionIds | Sort-Object -Unique).Count)) "facts=$((($factIds | Sort-Object -Unique).Count)), decisions=$((($decisionIds | Sort-Object -Unique).Count))"
Add-Result 'scores_cover_all_listing_ids' (@(Compare-Object ($factIds | Sort-Object -Unique) ($scoreIds | Sort-Object -Unique)).Count -eq 0) "fact_ids=$((($factIds | Sort-Object -Unique).Count)), score_ids=$((($scoreIds | Sort-Object -Unique).Count))"

$missingFactMeta = Missing-MetadataCount $facts @('session_id', 'batch_id', 'created_at', 'updated_at', 'phase_state')
$missingDecisionMeta = Missing-MetadataCount $decisions @('session_id', 'batch_id', 'created_at', 'updated_at', 'current_phase_state')
$missingScoreMeta = Missing-MetadataCount $scores @('session_id', 'batch_id', 'created_at', 'updated_at', 'criterion_state')
$missingSourceMeta = Missing-MetadataCount $sources @('session_id', 'batch_id', 'created_at', 'updated_at')

Add-Result 'facts_metadata_present' ($missingFactMeta -eq 0) "missing_rows=$missingFactMeta"
Add-Result 'decisions_metadata_present' ($missingDecisionMeta -eq 0) "missing_rows=$missingDecisionMeta"
Add-Result 'scores_metadata_present' ($missingScoreMeta -eq 0) "missing_rows=$missingScoreMeta"
Add-Result 'sources_metadata_present' ($missingSourceMeta -eq 0) "missing_rows=$missingSourceMeta"

$badFactStates = ($facts | Where-Object { $_.phase_state -notin $allowedFactStates }).Count
$badDecisionStates = ($decisions | Where-Object { $_.current_phase_state -notin $allowedDecisionStates }).Count
$badHardFilter = ($decisions | Where-Object { $_.hard_filter_status -notin $allowedHardFilterStatuses }).Count
$badRankable = ($decisions | Where-Object { $_.rankable_status -notin $allowedRankableStatuses }).Count

Add-Result 'fact_states_allowed' ($badFactStates -eq 0) "bad_rows=$badFactStates"
Add-Result 'decision_states_allowed' ($badDecisionStates -eq 0) "bad_rows=$badDecisionStates"
Add-Result 'hard_filter_status_allowed' ($badHardFilter -eq 0) "bad_rows=$badHardFilter"
Add-Result 'rankable_status_allowed' ($badRankable -eq 0) "bad_rows=$badRankable"

$factsById = @{}
foreach ($row in $facts) { $factsById[$row.listing_id] = $row }

$stateMismatch = 0
foreach ($decision in $decisions) {
  if ($factsById.ContainsKey($decision.listing_id)) {
    if ($factsById[$decision.listing_id].phase_state -ne $decision.current_phase_state) {
      $stateMismatch++
    }
  } else {
    $stateMismatch++
  }
}
Add-Result 'facts_and_decisions_state_alignment' ($stateMismatch -eq 0) "mismatches=$stateMismatch"

$badExtractedStates = ($decisions | Where-Object {
  $_.current_phase_state -eq 'phase2_extracted' -and $_.hard_filter_status -ne 'extracted'
}).Count
Add-Result 'phase2_rows_keep_extracted_status' ($badExtractedStates -eq 0) "bad_rows=$badExtractedStates"

$badTbdRankable = ($decisions | Where-Object {
  $_.hard_filter_status -eq 'hard_filter_tbd' -and $_.rankable_status -eq 'rankable'
}).Count
Add-Result 'no_tbd_listing_marked_rankable' ($badTbdRankable -eq 0) "bad_rows=$badTbdRankable"

$badFailedRankable = ($decisions | Where-Object {
  $_.hard_filter_status -eq 'hard_filter_failed' -and $_.rankable_status -eq 'rankable'
}).Count
Add-Result 'no_failed_listing_marked_rankable' ($badFailedRankable -eq 0) "bad_rows=$badFailedRankable"

$overBudgetNotFailed = 0
$overBudgetUnflagged = 0
foreach ($decision in $decisions) {
  $fact = $factsById[$decision.listing_id]
  $rent = Parse-Number $fact.normalized_monthly_rent_sgd
  if ($null -ne $rent -and $rent -gt 2000) {
    if ($decision.hard_filter_status -ne 'hard_filter_failed') {
      $overBudgetNotFailed++
    }
    $concerns = $decision.key_concerns
    $explicitlyFlagged = ($concerns -match 'over-budget|exceeds|above the user') -or
      ($decision.rankable_status -eq 'not_rankable_hard_filter_failed') -or
      ($decision.decision_notes -match 'failed-filter')
    if (-not $explicitlyFlagged) {
      $overBudgetUnflagged++
    }
  }
}
Add-Result 'over_budget_rows_fail_hard_filter' ($overBudgetNotFailed -eq 0) "bad_rows=$overBudgetNotFailed"
Add-Result 'over_budget_rows_explicitly_flagged' ($overBudgetUnflagged -eq 0) "bad_rows=$overBudgetUnflagged"

$scoreRowsMissingDecision = 0
$decisionIdSet = $decisionIds | Sort-Object -Unique
$decisionLookup = @{}
foreach ($id in $decisionIdSet) { $decisionLookup[$id] = $true }
foreach ($score in $scores) {
  if (-not $decisionLookup.ContainsKey($score.listing_id)) { $scoreRowsMissingDecision++ }
}
Add-Result 'all_score_rows_map_to_decision_listing_id' ($scoreRowsMissingDecision -eq 0) "bad_rows=$scoreRowsMissingDecision"

$illegalCriterionStates = 0
foreach ($score in $scores) {
  $decision = $decisions | Where-Object { $_.listing_id -eq $score.listing_id } | Select-Object -First 1
  if ($score.criterion_state -eq 'provisional_scored' -and $decision.current_phase_state -notin @('phase6_scored_provisional', 'phase6_scored_final')) {
    $illegalCriterionStates++
  }
}
Add-Result 'criterion_state_compatible_with_listing_state' ($illegalCriterionStates -eq 0) "bad_rows=$illegalCriterionStates"

if ($humanOutput.Count -gt 0) {
  $factLookup = @{}
  foreach ($fact in $facts) {
    $key = '{0}|{1}|{2}' -f $fact.source_name, $fact.listing_name, $fact.exact_listing_url
    $factLookup[$key] = $true
  }
  $humanMissing = 0
  foreach ($row in $humanOutput) {
    $key = '{0}|{1}|{2}' -f $row.source_name, $row.apartment_or_room_style, $row.exact_listing_url
    if (-not $factLookup.ContainsKey($key)) {
      $humanMissing++
    }
  }
  Add-Result 'human_output_rows_map_to_canonical_listing_ids' ($humanMissing -eq 0) "bad_rows=$humanMissing"
}

$script:results | ForEach-Object {
  Write-Output ("[{0}] {1} - {2}" -f $_.Status, $_.Check, $_.Details)
}

if (($script:results | Where-Object { $_.Status -eq 'FAIL' }).Count -gt 0) {
  exit 1
}
