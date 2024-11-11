import type {
	IExecuteFunctions,
	INodeExecutionData,
	INodeType,
	INodeTypeDescription,
} from 'n8n-workflow';
import { NodeOperationError } from 'n8n-workflow';
import Ajv from 'ajv';
export class Validate implements INodeType {
	description: INodeTypeDescription = {
		displayName: 'Validate',
		name: 'validate',
		group: ['transform'],
		version: 1,
		description: 'Basic Validate',
		defaults: {
			name: 'Validate',
		},
		inputs: ['main'],
		outputs: ['main'],
		properties: [
			// Node properties which the user gets displayed and
			// can change on the node.
			{
				displayName: 'Schema',
				name: 'schema',
				type: 'json',
				default: '{}',
				placeholder: 'Placeholder value',
				description: 'The description text',
			},
			{
				displayName: 'Data',
				name: 'data',
				type: 'json',
				default: '{}',
				description: 'The description text',
			}
		],
	};

	// The function below is responsible for actually doing whatever this node
	// is supposed to do. In this case, we're just appending the `myString` property
	// with whatever the user has entered.
	// You can make async calls and use `await`.
	async execute(this: IExecuteFunctions): Promise<INodeExecutionData[][]> {
		const ajv = new Ajv();
		const schema = this.getNodeParameter('schema', 0) as object;
		const data = this.getNodeParameter('data', 0) as object;
		const validate = ajv.compile(schema);
		const valid = validate(data);
		if (!valid) {
			throw new NodeOperationError(this.getNode(), 'Invalid data', {
			});
		}
		return [this.helpers.returnJsonArray([{ valid }])];
	}
}
