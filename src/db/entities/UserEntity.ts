import { Entity, PrimaryGeneratedColumn, Column } from "typeorm";
import { BaseEntity } from './BaseEntity';
import { User } from "../../models/User";

@Entity({ name: 'users' })
export class UserEntity extends BaseEntity implements User {

    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ name: 'first_name' })
    firstName: string;

    @Column({ name: 'last_name' })
    lastName: string;

}