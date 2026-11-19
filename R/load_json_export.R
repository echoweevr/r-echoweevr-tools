#' Load a JSON export from echoweevr
#'
#' Takes an input file path, loads its contents, and returns a usable tibble.
#'
#' The export contents it expects looks like the following:
#' ```json
#' [
#'  {
#'    "responseId": "002133ec-d559-455f-9da3-9922c480d561",
#'    "respondentId": "119236218629",
#'    "questionKey": "what_is_one_task_youd_never_trust_ai_to_do_why",
#'    "response": "All",
#'    "codes": [
#'      {
#'        "key": "distrust_everything",
#'       "source": "ai"
#'     }
#'    ]
#'  },
#'  {
#'    "responseId": "00adf06f-41c1-4530-9f5d-18d0c077a326",
#'    "respondentId": "119236189127",
#'    "questionKey": "what_ai_mistake_has_affected_you",
#'    "response": "not really because I examine every details before using it",
#'    "codes": [
#'      {
#'       "key": "no_mistake_experienced",
#'       "source": "ai"
#'      },
#'      {
#'        "key": "verification_caught_error",
#'        "source": "ai"
#'      }
#'    ]
#'  }
#']
#'````
#'
#'...and turns it into a tibble that looks like the following:
#'
#' A tibble: 3 × 6
#' response_id                          respondent_id question_key                        response code  source
#'   <chr>                                <chr>         <chr>                               <chr>    <chr> <chr>
#' 1 002133ec-d559-455f-9da3-9922c480d561 119236218629  what_is_one_task_youd_never_trust_… All      dist… ai
#' 2 00adf06f-41c1-4530-9f5d-18d0c077a326 119236189127  what_ai_mistake_has_affected_you    not rea… no_m… ai
#' 3 00adf06f-41c1-4530-9f5d-18d0c077a326 119236189127  what_ai_mistake_has_affected_you    not rea… veri… ai
#'
#' @param jsonfile The path of the file to import
#' @return A tibble of the JSON file, with one row per code
#' @export
load_json_export <- function(jsonfile) {
  responses <- jsonlite::fromJSON(jsonfile, simplifyVector = FALSE)
  coded_responses <- purrr::map_dfr(responses, function(r) {
    if (length(r$codes) == 0) {
      return(tibble::tibble(
        response_id = r$responseId,
        respondent_id = r$respondentId,
        question_key = r$questionKey,
        response = r$response,
        code = NA_character_,
        source = NA_character_
      ))
    }

    purrr::map_dfr(r$codes, function(c) {
      tibble::tibble(
        response_id = r$responseId,
        respondent_id = r$respondentId,
        question_key = r$questionKey,
        response = r$response,
        code = c$key,
        source = c$source
      )
    })
  })
  coded_responses
}
