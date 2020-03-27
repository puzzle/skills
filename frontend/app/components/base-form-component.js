import { action } from "@ember/object";
import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { inject as service } from "@ember/service";

export default class BaseFormComponent extends Component {
  @service intl;
  @service notify;

  @tracked
  record;

  beforeSubmit() {}

  handleSubmitError() {}

  handleSubmitSuccessful(savedRecords) {}

  afterSubmit() {}

  @action
  submit(recordsToSave) {
    this.beforeSubmit();
    recordsToSave = Array.isArray(recordsToSave)
      ? recordsToSave
      : [recordsToSave];

    let notPersistedRecords = recordsToSave.filter(
      record => record.hasDirtyAttributes
    );
    return Promise.all(notPersistedRecords.map(record => record.save()))
      .then(savedRecords => {
        this.handleSubmitSuccessful(savedRecords);
        this.afterSubmit();
      })
      .catch(() => {
        this.handleSubmitError();
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
        this.afterSubmit();
      });
  }
}
