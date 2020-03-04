# 4.3.0

### Features

- **Sentry:** Skills ist nun Sentry-kompatibel!
- **Env Variabeln per Endpoint:** Benötigte Environment Variabeln für das Frontend können per Endpoint abgefragt werden.

### Improvements

- **Ember Upgrade:** Ember-cli Versions Upgrade auf 3.15
- **Rails Upgrade:** Rails Versions Upgrade auf 6
- **README:** Readme deutlich verbessert in Struktur und Inhalt
- **Docker Image:** Ein Skills Docker Image wurde auf Dockerhub veröffentlicht
- **Department und PersonRole Level:** Die Departments und PersonRole levels wurden aus dem settings.yml in die Datenbank verschoben

# 4.2.0

### Features

- **Skills:** Es gibt eine Skills Seite für Admins zur Verwaltung
- **Person Skills:** Man kann einer Person nun neben dem CV auch Skills hinzufügen. Dabei können verschiedene Werte gesetzt werden.

### Improvements

- **Kernkompetenzen:** Die Kernkompetenzen werden neu durch die Skills der Person abgefüllt. Alte Kernkompetenzen sind noch als Notiz vorhanden

# 4.1.1

### Features

- **CV-Suche:** Die kompletten CVs der Nutzer können über den Tab Suche wieder durchsucht werden.

### Improvements

- **Header:** Der Header ist nun Sticky und scrollt mit.
- **Daterange-Attribute:** Die Daterange Attribute in Educations, Advanced Trainings, Activities, und Projects sind nun separate Felder, statt Date Attribute.
- **Neues CV-Template:** Das CV-Template wurde geupdated
- **Company-Type:** Das my_company Feld auf der Person wurde mit dem Enum company_type ausgetauscht.
