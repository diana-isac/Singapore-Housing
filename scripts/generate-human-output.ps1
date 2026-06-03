$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot

$facts = Import-Csv (Join-Path $root 'data\listing_facts.csv')
$decisions = Import-Csv (Join-Path $root 'data\listing_decisions.csv')

$factById = @{}
foreach ($fact in $facts) {
  $factById[$fact.listing_id] = $fact
}

function Parse-Number {
  param([string]$Value)
  if ([string]::IsNullOrWhiteSpace($Value)) { return $null }
  $number = 0.0
  if ([double]::TryParse($Value, [ref]$number)) { return $number }
  return $null
}

function Format-Score {
  param($Earned, $Possible)
  $earnedValue = Parse-Number $Earned
  $possibleValue = Parse-Number $Possible
  if ($null -eq $earnedValue -or $null -eq $possibleValue) { return '' }
  return ('{0}/{1}' -f [int][math]::Round($earnedValue, 0), [int][math]::Round($possibleValue, 0))
}

function Format-Currency {
  param($Value, [string]$Prefix)
  $number = Parse-Number $Value
  if ($null -eq $number) { return '' }
  if ([math]::Abs($number - [math]::Round($number, 0)) -lt 0.00001) {
    return ('{0} {1}' -f $Prefix, [int][math]::Round($number, 0))
  }
  return ('{0} {1:N2}' -f $Prefix, $number)
}

function Get-SortWeight {
  param([string]$RankableStatus)
  switch ($RankableStatus) {
    'rankable' { return 0 }
    'review_only_hard_filter_tbd' { return 1 }
    'not_rankable_extraction_only' { return 2 }
    'not_rankable_hard_filter_failed' { return 3 }
    default { return 4 }
  }
}

$rows = foreach ($decision in $decisions) {
  if (-not $factById.ContainsKey($decision.listing_id)) { continue }
  $fact = $factById[$decision.listing_id]
  $costSgd = if (-not [string]::IsNullOrWhiteSpace($fact.normalized_total_all_in_sgd)) {
    $fact.normalized_total_all_in_sgd
  } else {
    $fact.normalized_monthly_rent_sgd
  }
  $costUsd = if (-not [string]::IsNullOrWhiteSpace($fact.normalized_total_all_in_usd)) {
    $fact.normalized_total_all_in_usd
  } else {
    $fact.normalized_monthly_rent_usd
  }
  $possibleTotal = $decision.positive_points_possible
  [pscustomobject][ordered]@{
    sort_rankable_weight = Get-SortWeight $decision.rankable_status
    sort_total_score = Parse-Number $decision.total_score_after_penalties
    sort_minutes = if ([string]::IsNullOrWhiteSpace($fact.commute_minutes_to_smu)) { 9999 } else { [int][math]::Round((Parse-Number $fact.commute_minutes_to_smu), 0) }
    source_name = $fact.source_name
    apartment_or_room_style = $fact.listing_name
    cost_sgd = Format-Currency $costSgd 'SGD'
    cost_usd = Format-Currency $costUsd 'USD'
    minutes_from_smu = if ([string]::IsNullOrWhiteSpace($fact.commute_minutes_to_smu)) { '' } else { [int][math]::Round((Parse-Number $fact.commute_minutes_to_smu), 0) }
    total_score = Format-Score $decision.total_score_after_penalties $possibleTotal
    exact_listing_url = $fact.exact_listing_url
    lease_fit_score = Format-Score $decision.lease_fit_points_earned 5
    cost_score = Format-Score $decision.cost_points_earned 25
    location_score = Format-Score $decision.location_points_earned 20
    living_arrangement_score = Format-Score $decision.living_arrangement_points_earned 28
    unit_quality_score = Format-Score $decision.unit_quality_points_earned 26
    trust_score = Format-Score $decision.trust_points_earned 10
  }
}

$rows |
  Sort-Object sort_rankable_weight, @{ Expression = 'sort_total_score'; Descending = $true }, sort_minutes, source_name, apartment_or_room_style |
  Select-Object source_name, apartment_or_room_style, cost_sgd, cost_usd, minutes_from_smu, total_score, exact_listing_url, lease_fit_score, cost_score, location_score, living_arrangement_score, unit_quality_score, trust_score |
  Export-Csv (Join-Path $root 'data\listing_output_human.csv') -NoTypeInformation
