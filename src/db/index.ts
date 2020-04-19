import 'reflect-metadata';
import {
  createConnection,
  Connection,
  ConnectionOptions,
  Repository,
  getRepository,
} from 'typeorm';
import { PersonEntity } from './entities/PersonEntity';

const connectionOptions: ConnectionOptions = {
  type: 'postgres',
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT, 10),
  username: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  synchronize: true,
  logging: false,
  // use "js" because this will run after transpiling
  entities: [__dirname + '/entities/**/*.js'],
};

export function init(): Promise<Connection> {
  return createConnection(connectionOptions).then(createRepositories);
}

export let PersonRepository: Repository<PersonEntity> = null;

function createRepositories(connection: Connection): Connection {
  PersonRepository = getRepository(PersonEntity);

  return connection;
}

export { PersonEntity } from './entities/PersonEntity';
