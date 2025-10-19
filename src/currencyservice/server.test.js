const grpc = require('@grpc/grpc-js');
const path = require('path');
const protoLoader = require('@grpc/proto-loader');

// Load proto just like the server
const PROTO_PATH = path.join(__dirname, './proto/demo.proto');
const packageDef = protoLoader.loadSync(PROTO_PATH, {
  keepCase: true,
  longs: String,
  enums: String,
  defaults: true,
  oneofs: true
});
const shopProto = grpc.loadPackageDefinition(packageDef).hipstershop;

// Import functions directly from the server for testing
const {
  getSupportedCurrencies,
  convert,
  check
} = require('./server');

// Use fake gRPC call objects
function makeFakeCall(request) {
  return { request };
}

describe('CurrencyService', () => {

  test('getSupportedCurrencies should return currency codes', done => {
    getSupportedCurrencies(makeFakeCall({}), (err, res) => {
      expect(err).toBeNull();
      expect(res).toHaveProperty('currency_codes');
      expect(Array.isArray(res.currency_codes)).toBe(true);
      expect(res.currency_codes.length).toBeGreaterThan(0);
      done();
    });
  });

  test('convert should correctly convert CHF to EUR', done => {
    const request = {
      from: { currency_code: 'CHF', units: 100, nanos: 0 },
      to_code: 'EUR'
    };

    convert(makeFakeCall(request), (err, res) => {
      expect(err).toBeNull();
      expect(res).toHaveProperty('currency_code', 'EUR');
      expect(res.units).toBeGreaterThan(0);
      done();
    });
  });

  test('check should return SERVING status', done => {
    check(makeFakeCall({}), (err, res) => {
      expect(err).toBeNull();
      expect(res).toHaveProperty('status', 'SERVING');
      done();
    });
  });
});
