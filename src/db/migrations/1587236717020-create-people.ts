import { MigrationInterface, QueryRunner } from 'typeorm';

export class createPeople1587236717020 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<any> {
    await queryRunner.query(`CREATE TABLE people (
            id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
            first_name character varying NOT NULL,
            last_name character varying NOT NULL,
            created_at timestamp with time zone NOT NULL DEFAULT now(),
            updated_at timestamp with time zone NOT NULL DEFAULT now(),
            deleted_at timestamp with time zone
        );`);

    await queryRunner.query(
      `CREATE UNIQUE INDEX "PK_cace4a159ff9f2512dd42373760" ON people(id uuid_ops);`
    );
  }

  public async down(queryRunner: QueryRunner): Promise<any> {
    return queryRunner.dropTable('people');
  }
}
