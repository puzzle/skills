<p align="center">
  <a href="https://github.com/puzzle/skills">
    <img src="https://skills.puzzle.ch/logo.svg"  width="400" height="82">
  </a>
</p>


## Configuration

### LDAP config

The following environment variables are required for using ldap:

| Umgebungsvariable | Beschreibung                                       | Default |
| ----------------- | -------------------------------------------------- | ------- |
| LDAP_BASENAME     | LDAP Base name, e.g. ou=users,dc=yourdomain,dc=com | -       |
| LDAP_HOSTNAME     | LDAP Server host name                              | -       |
| LDAP_PORT         | LDAP Server Port                                   | 686     |

### Enable Authentication in development

Set the Environment variable ENABLE_AUTH to true in backend.

### Managing Data

Roles, departments and person-role-levels can't be updated, created or deleted through the UI. For this you must use the rails console.

-   Enter the root folder and type `rails c`
-   Establish the connection to the table: `Model.connection` e.g. `Role.connection`
-   Use `Model.create`, `Model.update` or `Model.delete` for your desired action.

Model names: Role, PersonRoleLevel, Department

Exact documentation for these methods can be found [here](https://guides.rubyonrails.org/active_record_basics.html#crud-reading-and-writing-data)

### Managing Categories

Categories can be added using the [skill_config.yml](https://github.com/puzzle/skills/blob/master/config/skill_config.yml) file.

But they can't be removed or updated this way. They have to be updated/deleted manually like the roles above.
