import { action } from "@ember/object";
import Component from "@glimmer/component";
import { inject as service } from "@ember/service";

export default class SubmitBaseComponent extends Component {
  @service intl;
  @service notify;

  @action
  submit(recordsToSave) {
    let notPersistedRecords = recordsToSave.filter(
      record => record.hasDirtyAttributes
    );
    return Promise.all(notPersistedRecords.map(record => record.save())).catch(
      () => {
        let errors = notPersistedRecords.map(record => {
          return {
            model: record.constructor.modelName,
            recordErrors: record.errors.slice()
          };
        });

        errors.forEach(({ model, recordErrors }) => {
          recordErrors.forEach(({ attribute, message }) => {
            let translated_attribute = this.intl.t(`${model}.${attribute}`);
            this.notify.alert(`${translated_attribute} ${message}`, {
              closeAfter: 10000
            });
          });
        });
      }
    );
  }
}
