import { PersonValidator } from '../../src/validators/PersonValidator';
import { ValidationError } from '../../src/errors/ValidationError';
import { Person } from '../../src/models/Person';

describe('PersonValidator', () => {
  it('expects an object', () => {
    expect(() => PersonValidator.assertValid(null)).toThrow(
      new ValidationError('person is null or undefined')
    );
  });

  it.each([
    [{}],
    [{ firstName: 1 }],
    [{ firstName: null }],
    [{ firstName: '' }],
    [{ firstName: true }],
    [{ firstName: new Date() }],
  ])('throws an error for an invalid firstName: %j', (person: Person) => {
    let error;

    person.lastName = 'some-valid-field';

    try {
      PersonValidator.assertValid(person);
    } catch (e) {
      error = e;
    }

    expect(error).toBeInstanceOf(ValidationError);
    expect(error.message).toBe('Invalid properties: [ firstName ]');
    expect(error.reasons).toMatchObject([
      'firstName must be a required nonempty string',
    ]);
  });

  it.each([
    [{}],
    [{ lastName: 1 }],
    [{ lastName: null }],
    [{ lastName: '' }],
    [{ lastName: true }],
    [{ lastName: new Date() }],
  ])('throws an error for an invalid lastName: %j', (person: Person) => {
    let error;

    person.firstName = 'some-valid-field';

    try {
      PersonValidator.assertValid(person);
    } catch (e) {
      error = e;
    }

    expect(error).toBeInstanceOf(ValidationError);
    expect(error.message).toBe('Invalid properties: [ lastName ]');
    expect(error.reasons).toMatchObject([
      'lastName must be a required nonempty string',
    ]);
  });

  it('throws an error for a multiple invalid fields', () => {
    let error;

    const person = {
      firstName: 1,
      lastName: true,
    };

    try {
      PersonValidator.assertValid((person as unknown) as Person);
    } catch (e) {
      error = e;
    }

    expect(error).toBeInstanceOf(ValidationError);
    expect(error.message).toBe('Invalid properties: [ firstName, lastName ]');
    expect(error.reasons).toMatchObject([
      'firstName must be a required nonempty string',
      'lastName must be a required nonempty string',
    ]);
  });
});
