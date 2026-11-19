#' Counts the number of respondents by question key
#'
#' @param coded_responses A tibble of responses loaded from an export JSON
#' @return A tibble of respondent counts by question key
#' @export
number_respondents_by_question <- function(coded_responses) {
  coded_responses |>
    dplyr::group_by(question_key) |>
    dplyr::summarise(
      respondents = dplyr::n_distinct(respondent_id),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(respondents))
}
