"use strict";

var _interopRequireDefault = require("@babel/runtime/helpers/interopRequireDefault");

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.serializePathv2 = serializePathv2;
exports.signSendChunkv2 = signSendChunkv2;
exports.publicKeyv2 = publicKeyv2;

var _regenerator = _interopRequireDefault(require("@babel/runtime/regenerator"));

var _asyncToGenerator2 = _interopRequireDefault(require("@babel/runtime/helpers/asyncToGenerator"));

var _helperV = require("./helperV1");

var _common = require("./common");

function serializePathv2(path) {
  if (!path || path.length !== 5) {
    throw new Error("Invalid path.");
  }

  var buf = Buffer.alloc(20);
  buf.writeUInt32LE(0x80000000 + path[0], 0);
  buf.writeUInt32LE(0x80000000 + path[1], 4);
  buf.writeUInt32LE(0x80000000 + path[2], 8);
  buf.writeUInt32LE(path[3], 12);
  buf.writeUInt32LE(path[4], 16);
  return buf;
}

function signSendChunkv2(_x, _x2, _x3, _x4) {
  return _signSendChunkv.apply(this, arguments);
}

function _signSendChunkv() {
  _signSendChunkv = (0, _asyncToGenerator2.default)( /*#__PURE__*/_regenerator.default.mark(function _callee(app, chunkIdx, chunkNum, chunk) {
    var payloadType;
    return _regenerator.default.wrap(function _callee$(_context) {
      while (1) {
        switch (_context.prev = _context.next) {
          case 0:
            payloadType = _common.PAYLOAD_TYPE.ADD;

            if (chunkIdx === 1) {
              payloadType = _common.PAYLOAD_TYPE.INIT;
            }

            if (chunkIdx === chunkNum) {
              payloadType = _common.PAYLOAD_TYPE.LAST;
            }

            return _context.abrupt("return", (0, _helperV.signSendChunkv1)(app, payloadType, 0, chunk));

          case 4:
          case "end":
            return _context.stop();
        }
      }
    }, _callee);
  }));
  return _signSendChunkv.apply(this, arguments);
}

function publicKeyv2(_x5, _x6) {
  return _publicKeyv.apply(this, arguments);
}

function _publicKeyv() {
  _publicKeyv = (0, _asyncToGenerator2.default)( /*#__PURE__*/_regenerator.default.mark(function _callee2(app, data) {
    return _regenerator.default.wrap(function _callee2$(_context2) {
      while (1) {
        switch (_context2.prev = _context2.next) {
          case 0:
            return _context2.abrupt("return", app.transport.send(_common.CLA, _common.INS.GET_ADDR_SECP256K1, 0, 0, data, [_common.ERROR_CODE.NoError]).then(function (response) {
              var errorCodeData = response.slice(-2);
              var returnCode = errorCodeData[0] * 256 + errorCodeData[1];
              var compressedPk = Buffer.from(response.slice(0, 33));
              return {
                pk: "OBSOLETE PROPERTY",
                compressed_pk: compressedPk,
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