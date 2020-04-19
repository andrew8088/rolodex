import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';
import { BaseEntity } from './BaseEntity';
import { Person } from '../../models/Person';

@Entity({ name: 'people' })
export class PersonEntity extends BaseEntity implements Person {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'first_name' })
  firstName: string;

  @Column({ name: 'last_name' })
  lastName: string;
}
