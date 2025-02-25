import * as fs from 'fs';

const queryStart = `INSERT INTO products (productID, productName, price) VALUES `;

class Row_Product
{
    private id: string;
    private name: string;
    private price: number;

    constructor(id: string, name: string, price: number)
    {
        this.id = id;
        this.name = name;
        this.price = price;
    }

    INSERT_String() : string {
        return `${queryStart} ('${this.id}', '${this.name}', ${this.price});`
    }
}

// Function to read and transform JSON
function ReadJSON(filePath: string): any[] {
  try {
    const rawData = fs.readFileSync(filePath, 'utf-8');
    return JSON.parse(rawData);
    } catch (error) {
    console.error('Error(s) occurred! ', error);
    return [];
  }
}

function BuildRowsFromJSON(jsonData: any[]): Row_Product[] {
    if (jsonData.length < 1) {
        return [];
    }

    return jsonData.map((item: any) => {
        const id = item.ProductID ? item.ProductID : '?';
        const name = item.ProductName || '?';
        const price = item.Price || '-1';

        return new Row_Product(id, name, price);
    });
}


// Read JSON in, build rows, then write rows to file.
const json = ReadJSON('data.json');
const rows = BuildRowsFromJSON(json);
console.log(rows);

