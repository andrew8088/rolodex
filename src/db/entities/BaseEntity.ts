import { Column } from 'typeorm';
import { Base } from '../../models/Base';

export class BaseEntity implements Base {
  @Column({ name: 'created_at', type: 'timestamp with time zone' })
  createdAt?: Date;

  @Column({ name: 'updated_at', type: 'timestamp with time zone' })
  updatedAt?: Date;

  @Column({
    name: 'deleted_at',
    type: 'timestamp with time zone',
    nullable: true,
  })
  deletedAt?: Date;
}
