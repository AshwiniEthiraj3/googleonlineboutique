const grpc = require('@grpc/grpc-js');
const HipsterShopServer = require('../server');

describe('PaymentService gRPC Server', () => {
  let server;

  beforeAll(() => {
    process.env.PORT = '50051';
    server = new HipsterShopServer('./proto', process.env.PORT);
  });

  test('should initialize server with gRPC services', () => {
    expect(server).toBeDefined();
    expect(server.port).toBe('50051');
    expect(server.packages.hipsterShop).toBeDefined();
    expect(server.packages.health).toBeDefined();
  });

  test('ChargeServiceHandler should call charge() and return a valid response', done => {
    // Mock the charge function
    jest.mock('../charge', () => jest.fn(() => ({ transaction_id: 'tx-123' })));
    const mockCall = { request: { amount: 100 } };

    HipsterShopServer.ChargeServiceHandler(mockCall, (err, res) => {
      expect(err).toBeNull();
      expect(res).toHaveProperty('transaction_id');
      done();
    });
  });

  test('CheckHandler should respond SERVING', done => {
    const mockCall = {};
    HipsterShopServer.CheckHandler(mockCall, (err, res) => {
      expect(err).toBeNull();
      expect(res.status).toBe('SERVING');
      done();
    });
  });
});
