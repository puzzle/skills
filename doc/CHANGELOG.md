# 5.0.0 - The Big Rewrite

### Features

- **Tech-Stack** Kompletter Rewrite des Tech-Stacks. EmberJS wurde entfernt und dessen Funktionalität durch Rails + Hotwire "Feature complete" ersetzt.
- **Docker Setup** Dank dem extrem vereinfachten Tech-Stack ist das Docker Setup nun auch entsprechend funtkioneller.

# 4.4.0

### Features

- **Skill AND Suche** Es kann nun nach mehreren Skills gleichzeitig gesucht werden.
- **Kein End-Datumszwang** Es können nun Profileinträge ohne End-Datum eingetragen werden (https://github.com/puzzle/skills/issues/450).
- **CV-Search "go-back" verhalten"** Die CV-Suche speichert nun den letzten Sucheintrag und geht generell intelligenter mit der Browser History um.
- **CV-Export Skill-Level Filter** Es können nun nur Skills die ein Mindest-Level erfüllen im Export inkludiert werden.
- **ESC Verhalten in den Forms** Die Forms werden nun nicht automatisch mit ESC geschlossen sondern ändern in einem ersten Schritt nur den Fokus aufs aktuelle Feld und lösen dann noch einen Dialog aus bevor der Input gelöscht wird. (https://github.com/puzzle/skills/issues/392)
- **Frontend Cleanup** Im Frontend wurde einiges aufgeräumt und homogenisiert.

# 4.3.0

### Features

- **Sentry:** Skills ist nun Sentry-kompatibel!
- **Env Variabeln per Endpoint:** Benötigte Environment Variabeln für das Frontend können per Endpoint abgefragt werden.
- **Cv Suche mit Gefunden in:** Cv Suche zeigt nun an, wo der gesuchte Begriff gefunden wurde, zudem kann man direkt dorthin springen.
- **Skill Suche mindest Erfahrung:** Skill Suche erlaubt es nun, die mindest Erfahrung festzulegen.
- **Anonymisiertes CV:** CVs können ohne die persönlichen Daten exportiert werden.


### Improvements

- **Ember Upgrade:** Ember-cli Versions Upgrade auf 3.15
- **Rails Upgrade:** Rails Versions Upgrade auf 6
- **README:** Readme deutlich verbessert in Struktur und Inhalt
- **Docker Image:** Ein Skills Docker Image wurde auf Dockerhub veröffentlicht
- **Department und PersonRole Level:** Die Departments und PersonRole levels wurden aus dem settings.yml in die Datenbank verschoben
- **Bugfix:** [Skill erstellen Bugfix](https://github.com/puzzle/skills/issues/308)

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
