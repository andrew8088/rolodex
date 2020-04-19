import { Person } from '../models/Person';
import * as toi from '@toi/toi';
import { ValidationError } from '../errors/ValidationError';

const validator = toi.required().and(
  toi.obj.keys({
    firstName: toi.required().and(toi.str.nonempty()),
    lastName: toi.required().and(toi.str.nonempty()),
  })
);

export class PersonValidator {
  static assertValid(person: Person) {
    try {
      validator(person);
    } catch (error) {
      const invalidProps: string[] = [];
      const reasons: string[] = [];

      if (!error.reasons) {
        throw new ValidationError('person is null or undefined');
      }

      if (error.reasons.firstName) {
        invalidProps.push('firstName');
        reasons.push('firstName must be a required nonempty string');
      }

      if (error.reasons.lastName) {
        invalidProps.push('lastName');
        reasons.push('lastName must be a required nonempty string');
      }

      throw new ValidationError(
        `Invalid properties: [ ${invalidProps.join(', ')} ]`,
        reasons
      );
    }
  }
}
