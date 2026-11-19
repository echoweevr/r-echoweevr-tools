#' Pivot coded responses into binary indicator columns
#'
#' For a specific question, produces one row per respondent
#' and one column per code. Values are 1 if the code was
#' assigned to the respondent and 0 otherwise.
#'
#' @param coded_responses A tibble of responses loaded from
#'   an EchoWeevr JSON export.
#' @param question_key The key of the question to analyze.
#'
#' @return A tibble containing respondent IDs and binary
#'   indicator columns for each code.
#'
#' @importFrom rlang .data .env
#' @export
pivot_codes_wide <- function(coded_responses, question_key) {
  if (!question_key %in% coded_responses$question_key) {
    cli::cli_abort(
      "Question key {.val {question_key}} was not found."
    )
  }

  question_responses <- coded_responses |>
    dplyr::filter(.data$question_key == .env$question_key)

  respondents <- question_responses |>
    dplyr::distinct(.data$respondent_id)

  codes <- question_responses |>
    dplyr::filter(!is.na(.data$code)) |>
    dplyr::distinct(.data$respondent_id, .data$code) |>
    dplyr::mutate(present = 1L) |>
    tidyr::pivot_wider(
      id_cols = "respondent_id",
      names_from = "code",
      values_from = "present",
      values_fill = 0L
    )

  respondents |>
    dplyr::left_join(codes, by = "respondent_id") |>
    dplyr::mutate(
      dplyr::across(
        -dplyr::all_of("respondent_id"),
        ~ tidyr::replace_na(.x, 0L)
      )
    )
}
