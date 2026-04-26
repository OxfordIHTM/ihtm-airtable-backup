# Daily backups of Oxford IHTM Airtable Bases ----------------------------------


## Load libraries and custom functions ----
suppressPackageStartupMessages(source("packages.R"))
for (f in list.files(here::here("R"), full.names = TRUE)) source (f)


## Data targets ----
data_targets <- tar_plan(
  ihtm_metadata_base_id = Sys.getenv("IHTM_METADATA_BASE_ID"),
  tar_target(
    name = ihtm_metadata,
    command = {
      x <- airtabler::airtable(base = ihtm_metadata_base_id, table = "Metadata")
      x$Metadata$get()
    },
    cue = tar_cue("always")
  ),
  tar_target(
    name = ihtm_airtable_base_titles,
    command = ihtm_metadata |>
      dplyr::select(title),
    cue = tar_cue("always")
  ),
  tar_target(
    name = ihtm_airtable_base_ids,
    command = ihtm_metadata |>
      dplyr::select(base_id),
    cue = tar_cue("always")
  ),
  tar_target(
    name = ihtm_airtable_base_descriptions,
    command = ihtm_metadata |>
      dplyr::select(description),
    cue = tar_cue("always")
  ),
  tar_target(
    name = ihtm_airtable_metadata_structure,
    command = airtabler::air_generate_metadata_from_api(
      base = ihtm_airtable_base_ids
    ),
    pattern = map(ihtm_airtable_base_ids),
    iteration = "list"
  ),
  tar_target(
    name = ihtm_airtable_metadata_description,
    command = airtabler::air_generate_base_description(
      title = ihtm_airtable_base_titles, 
      description = ihtm_airtable_base_descriptions
    ),
    pattern = map(ihtm_airtable_base_titles, ihtm_airtable_base_descriptions),
    iteration = "list"
  ),
  tar_target(
    name = ihtm_airtable_backup,
    command = try(
      airtabler::air_dump(
        base = ihtm_airtable_base_ids,
        metadata = ihtm_airtable_metadata_structure,
        description = ihtm_airtable_metadata_description,
        field_names_to_snakecase = FALSE,
        dir_name = "data/downloads"
      )
    ),
    pattern = map(
      ihtm_airtable_base_ids, 
      ihtm_airtable_metadata_structure, 
      ihtm_airtable_metadata_description
    ),
    iteration = "list"
  )
)


## Processing targets ----
processing_targets <- tar_plan(
  
)


## Analysis targets ----
analysis_targets <- tar_plan(
  
)


## Output targets ----
output_targets <- tar_plan(
  
)


## Reporting targets ----
report_targets <- tar_plan(
  
)


## Deploy targets ----
deploy_targets <- tar_plan(
  
)


## List targets ----
all_targets()
