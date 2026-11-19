#' Counts the number of occurrences of each code by question key
#'
#' @param coded_responses A tibble of responses loaded from an export JSON
#' @param question_key The key of the question
#' @returns A tibble of counts by code
#' @importFrom rlang .data .env
#' @export
code_frequencies <- function(coded_responses, question_key) {
  coded_responses |>
    dplyr::filter(.data$question_key == .env$question_key) |>
    dplyr::distinct(response_id, code) |>
    dplyr::count(code, sort = TRUE)
}
