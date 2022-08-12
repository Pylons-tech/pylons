"use strict";

var _interopRequireDefault = require("@babel/runtime/helpers/interopRequireDefault");

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.serializePathv1 = serializePathv1;
exports.signSendChunkv1 = signSendChunkv1;
exports.publicKeyv1 = publicKeyv1;

var _regenerator = _interopRequireDefault(require("@babel/runtime/regenerator"));

var _asyncToGenerator2 = _interopRequireDefault(require("@babel/runtime/helpers/asyncToGenerator"));

var _common = require("./common");

function serializePathv1(path) {
  if (path == null || path.length < 3) {
    throw new Error("Invalid path.");
  }

  if (path.length > 10) {
    throw new Error("Invalid path. Length should be <= 10");
  }

  var buf = Buffer.alloc(1 + 4 * path.length);
  buf.writeUInt8(path.length, 0);

  for (var i = 0; i < path.length; i += 1) {
    var v = path[i];

    if (i < 3) {
      // eslint-disable-next-line no-bitwise
      v |= 0x80000000; // Harden
    }

    buf.writeInt32LE(v, 1 + i * 4);
  }

  return buf;
}

function signSendChunkv1(_x, _x2, _x3, _x4) {
  return _signSendChunkv.apply(this, arguments);
}

function _signSendChunkv() {
  _signSendChunkv = (0, _asyncToGenerator2.default)( /*#__PURE__*/_regenerator.default.mark(function _callee(app, chunkIdx, chunkNum, chunk) {
    return _regenerator.default.wrap(function _callee$(_context) {
      while (1) {
        switch (_context.prev = _context.next) {
          case 0:
            return _context.abrupt("return", app.transport.send(_common.CLA, _common.INS.SIGN_SECP256K1, chunkIdx, chunkNum, chunk, [_common.ERROR_CODE.NoError, 0x6984, 0x6a80]).then(function (response) {
              var errorCodeData = response.slice(-2);
              var returnCode = errorCodeData[0] * 256 + errorCodeData[1];
              var errorMessage = (0, _common.errorCodeToString)(returnCode);

              if (returnCode === 0x6a80 || returnCode === 0x6984) {
                errorMessage = "".concat(errorMessage, " : ").concat(response.slice(0, response.length - 2).toString("ascii"));
              }

              var signature = null;

              if (response.length > 2) {
                signature = response.slice(0, response.length - 2);
              }

              return {
                signature: signature,
                return_code: returnCode,
                error_message: errorMessage
              };
            }, _common.processErrorResponse));

          case 1:
          case "end":
            return _context.stop();
        }
      }
    }, _callee);
  }));
  return _signSendChunkv.apply(this, arguments);
}

function compressPublicKey(publicKey) {
  if (publicKey.length !== 65) {
    throw new Error("decompressed public key length should be 65 bytes");
  }

  var y = publicKey.slice(33, 65); // eslint-disable-next-line no-bitwise

  var z = Buffer.from([2 + (y[y.length - 1] & 1)]);
  return Buffer.concat([z, publicKey.slice(1, 33)]);
}

function publicKeyv1(_x5, _x6) {
  return _publicKeyv.apply(this, arguments);
}

function _publicKeyv() {
  _publicKeyv = (0, _asyncToGenerator2.default)( /*#__PURE__*/_regenerator.default.mark(function _callee2(app, data) {
    return _regenerator.default.wrap(function _callee2$(_context2) {
      while (1) {
        switch (_context2.prev = _context2.next) {
          case 0:
            return _context2.abrupt("return", app.transport.send(_common.CLA, _common.INS.INS_PUBLIC_KEY_SECP256K1, 0, 0, data, [_common.ERROR_CODE.NoError]).then(function (response) {
              var errorCodeData = response.slice(-2);
              var returnCode = errorCodeData[0] * 256 + errorCodeData[1];
              var pk = Buffer.from(response.slice(0, 65));
              return {
                pk: pk,
                compressed_pk: compressPublicKey(pk),
                return_code: returnCode,
                error_message: (0, _common.errorCodeToString)(returnCode)
              };
            }, _common.processErrorResponse));

          case 1:
          case "end":
            return _context2.stop();
        }
      }
    }, _callee2);
  }));
  return _publicKeyv.apply(this, arguments);
}