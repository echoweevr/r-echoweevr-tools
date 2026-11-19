#' Returns the percentage of codes for a question key over the number of respondents
#'
#' @param coded_responses A tibble of responses loaded from an export JSON
#' @param question_key The key of the question
#' @returns A tibble of percentages by code
#' @importFrom rlang .data .env
#' @export
code_prevalence <- function(coded_responses, question_key) {
  filtered_responses <- coded_responses |>
    dplyr::filter(.data$question_key == .env$question_key)

  denominator <- filtered_responses |>
    dplyr::distinct(respondent_id) |>
    dplyr::count() |>
    dplyr::pull()
    denominator

  filtered_responses |>
    dplyr::distinct(response_id, code) |>
    dplyr::count(code, sort = TRUE) |>
    dplyr::mutate(total = denominator, percentage = (n / total) * 100)

}
