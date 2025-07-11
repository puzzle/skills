# Work in progress

### Features
- **Open Source contributions** The possibility to add open source contributions to your profile as well has been implemented.

### Improvements
-

# 6.0.0

### Features
- **PuzzleTime Sync** The data of the people are now directly fetched from the PuzzleTime API using a nightly DelayedJob. (An extensive documentation can be found in the README.md)
- **Team skill tracking** The Skills application now automatically keeps track of the level and amount of rated skills inside a department. (See README.md for more information)
- **Different template for CV export** A Red Hat template has been added as an option when exporting the CV. The foundation has been laid to add more templates in the future.
- **Skill unification** Duplicates of skills can now be unified using an option in the admin view.
- **Certificate master** It is now possible to keep track of different certificates inside of PuzzleSkills.

### Improvements
- **Locales in cookies** The selected locale is now saved inside a cookie which results in automatically selecting this language once you visit PuzzleSkills.
- **Unrated skills disappear** When a skill is rated as 'not rated', it disappears from the profile.
- **Language localization** Added translations for Japanese and Swiss-German to the application.
- **Various translations** Translations for various parts of the application have been added and improved.

# 5.1.0

### Features
- **Language selection** Translations for English, French and Italian added.
- **Delete button for people** Add the missing delete button for people.

### Improvements
- **Turbo upgrade** Dropdowns and links are now turbo 8 friendly which includes pre-fetching of entries.
- **Rails upgrade** Rails version upgraded to 8.
- **Ruby upgrade** Ruby version upgraded to 3.4.1.
- **Future years to be selected** Allow future years to be selected in the from-to dropdown for person relations.

# 5.0.0 - The Big Rewrite

### Features

- **Tech-Stack** Complete rewrite of the tech stack. EmberJS was removed and its functionality has been replaced with Rails + Hotwire ("feature complete").
- **Docker Setup** Thanks to the significantly simplified tech stack, the Docker setup is now much more functional.

# 4.4.0

### Features

- **Skill AND Search** It is now possible to search for multiple skills simultaneously.
- **No End Date Required** Profile entries can now be created without an end date (https://github.com/puzzle/skills/issues/450).
- **CV-Search "go-back" behavior** The CV search now remembers the last search input and handles browser history more intelligently.
- **CV-Export Skill-Level Filter** Only skills that meet a minimum level can now be included in the export.
- **ESC Behavior in Forms** Forms are no longer closed immediately when pressing ESC. Instead, focus is first shifted to the current field, and a dialog appears before any input is deleted. (https://github.com/puzzle/skills/issues/392)
- **Frontend Cleanup** A lot has been cleaned up and unified in the frontend.

# 4.3.0

### Features

- **Sentry:** Skills is now compatible with Sentry!
- **Env Variables via Endpoint:** Required environment variables for the frontend can now be retrieved via an endpoint.
- **CV-Search with "Found in":** CV search now shows where the search term was found, and allows you to jump directly to that spot.
- **Skill Search Minimum Experience:** Skill search now allows setting a minimum experience level.
- **Anonymized CV:** CVs can now be exported without personal data.

### Improvements

- **Ember Upgrade:** Ember-cli version upgraded to 3.15.
- **Rails Upgrade:** Rails version upgraded to 6.
- **README:** README significantly improved in structure and content.
- **Docker Image:** A Skills Docker image has been published on Docker Hub.
- **Department and PersonRole Levels:** Departments and PersonRole levels were moved from `settings.yml` to the database.
- **Bugfix:** [Skill creation bugfix](https://github.com/puzzle/skills/issues/308)

# 4.2.0

### Features

- **Skills:** There is now a Skills page for admins to manage skills.
- **Person Skills:** You can now assign skills to a person in addition to their CV. Various values can be set in the process.

### Improvements

- **Core Competencies:** Core competencies are now populated based on the person’s skills. Old core competencies are still available as notes.

# 4.1.1

### Features

- **CV-Search:** Full user CVs can once again be searched via the Search tab.

### Improvements

- **Header:** The header is now sticky and scrolls with the page.
- **Date Range Attributes:** Date range attributes in Educations, Advanced Trainings, Activities, and Projects are now separate fields instead of date attributes.
- **New CV Template:** The CV template has been updated.
- **Company Type:** The `my_company` field on the person model has been replaced with the `company_type` enum.
