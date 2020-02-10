(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
    typeof define === 'function' && define.amd ? define(factory) :
    (global = global || self, global.ethereum = factory());
}(this, function () { 'use strict';

    /*! *****************************************************************************
    Copyright (c) Microsoft Corporation. All rights reserved.
    Licensed under the Apache License, Version 2.0 (the "License"); you may not use
    this file except in compliance with the License. You may obtain a copy of the
    License at http://www.apache.org/licenses/LICENSE-2.0

    THIS CODE IS PROVIDED ON AN *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED
    WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE,
    MERCHANTABLITY OR NON-INFRINGEMENT.

    See the Apache Version 2.0 License for specific language governing permissions
    and limitations under the License.
    ***************************************************************************** */

    var __assign = function() {
        __assign = Object.assign || function __assign(t) {
            for (var s, i = 1, n = arguments.length; i < n; i++) {
                s = arguments[i];
                for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p)) t[p] = s[p];
            }
            return t;
        };
        return __assign.apply(this, arguments);
    };

    function __awaiter(thisArg, _arguments, P, generator) {
        return new (P || (P = Promise))(function (resolve, reject) {
            function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
            function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
            function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
            step((generator = generator.apply(thisArg, _arguments || [])).next());
        });
    }

    function __generator(thisArg, body) {
        var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
        return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
        function verb(n) { return function (v) { return step([n, v]); }; }
        function step(op) {
            if (f) throw new TypeError("Generator is already executing.");
            while (_) try {
                if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
                if (y = 0, t) op = [op[0] & 2, t.value];
                switch (op[0]) {
                    case 0: case 1: t = op; break;
                    case 4: _.label++; return { value: op[1], done: false };
                    case 5: _.label++; y = op[1]; op = [0]; continue;
                    case 7: op = _.ops.pop(); _.trys.pop(); continue;
                    default:
                        if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                        if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                        if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                        if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                        if (t[2]) _.ops.pop();
                        _.trys.pop(); continue;
                }
                op = body.call(thisArg, _);
            } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
            if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
        }
    }

    var u = navigator.userAgent;
    var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1; //android终端
    var funcQueue = [];
    function addFunction(id, func) {
        funcQueue.push({
            id: id,
            func: func,
        });
    }
    window.executeCallback = function (id, error, value) {
        for (var i = 0; i < funcQueue.length; i++) {
            var func = funcQueue[i];
            if (func.id === id) {
                func.func(error, value);
            }
        }
    };
    var signTransaction = function (payload) {
        var id = payload.id || 99999999;
        var chainType = 'ETH';
        return new Promise(function (resolve, reject) {
            addFunction(id, function (error, value) {
                if (error) {
                    reject(error);
                    return;
                }
                resolve({
                    jsonrpc: '2.0',
                    id: id,
                    result: value,
                    error: null,
                });
            });
            var tx = payload.params[0];
            if (isAndroid) {
                window.hiWallet.signTransaction(id, chainType, tx.to || null, tx.value, tx.nonce, tx.gas || tx.gasLimit, tx.gasPrice, tx.data);
            }
            else {
                window.webkit.messageHandlers.signTransaction.postMessage({
                    name: 'signTransaction',
                    chainType: chainType,
                    object: __assign(__assign({}, tx), { gasLimit: tx.gas || tx.gasLimit }),
                    id: id,
                });
            }
        });
    };
    var signPersonalMessage = function (payload) {
        var id = payload.id || 99999998;
        var chainType = 'ETH';
        return new Promise(function (resolve, reject) {
            addFunction(id, function (error, value) {
                if (error) {
                    reject(error);
                    return;
                }
                resolve({
                    jsonrpc: '2.0',
                    id: id,
                    result: value,
                    error: null,
                });
            });
            var data = payload.params[0];
            if (isAndroid) {
                window.hiWallet.signPersonalMessage(id, data);
            }
            else {
                window.webkit.messageHandlers.signPersonalMessage.postMessage({
                    name: 'signPersonalMessage',
                    chainType: chainType,
                    object: { data: data },
                    id: id,
                });
            }
        });
    };
    var sign = function (payload) {
        var id = payload.id || 99999997;
        var chainType = 'ETH';
        return new Promise(function (resolve, reject) {
            addFunction(id, function (error, value) {
                if (error) {
                    reject(error);
                    return;
                }
                resolve({
                    jsonrpc: '2.0',
                    id: id,
                    result: value,
                    error: null,
                });
            });
            var data = payload.params[1];
            if (isAndroid) {
                window.hiWallet.signMessage(id, data);
            }
            else {
                window.webkit.messageHandlers.signMessage.postMessage({
                    name: 'signMessage',
                    chainType: chainType,
                    object: { data: data },
                    id: id,
                });
            }
        });
    };

    var EthProvider = /** @class */ (function () {
        /**
         * @param {string} host
         *
         * @constructor
         */
        function EthProvider(host) {
            this.isHiwallet = true;
            this.isImToken = true;
            this.isMetaMask = true;
            this.host = host;
            window.imToken = true;
            window.isMetaMask = true;
        }
        /**
         * Async function
         * Creates the JSON-RPC payload and sends it to the node.
         *
         * @method send
         *
         * @param {JsonRPCRequest} payload
         *
         * @returns {JsonRPCResponse}
         */
        EthProvider.prototype.send = function (payload) {
            if (payload.method === 'eth_accounts') {
                // 获取账户
                return {
                    jsonrpc: '2.0',
                    id: payload.id,
                    result: [window.addressHex],
                    error: null,
                };
            }
            try {
                var request = new XMLHttpRequest();
                request.open('POST', this.host, false);
                request.send(JSON.stringify(payload));
                var result = request.responseText;
                result = JSON.parse(result);
                return result;
            }
            catch (error) {
                throw error;
            }
        };
        /**
         * Creates the JSON-RPC payload and sends it to the node.
         *
         * @method send
         *
         * @param {JsonRPCRequest} payload
         * @param {Function} cb
         *
         * @returns {Promise<JsonRPCResponse>}
         */
        EthProvider.prototype.sendAsync = function (payload, cb) {
            this.sendPayload(payload)
                .then(function (res) {
                if (cb) {
                    cb(null, res);
                }
            })
                .catch(function (e) {
                if (cb) {
                    cb(e, null);
                }
            });
        };
        /**
         * Creates the JSON-RPC batch payload and sends it to the node.
         *
         * @method sendBatch
         *
         * @param {JsonRPCRequest[]} payloads
         *
         * @returns {Promise<JsonRPCResponse[]>}
         */
        EthProvider.prototype.sendBatch = function (payloads, cb) {
            return __awaiter(this, void 0, void 0, function () {
                var responses, error_1;
                var _this = this;
                return __generator(this, function (_a) {
                    switch (_a.label) {
                        case 0:
                            _a.trys.push([0, 2, , 3]);
                            return [4 /*yield*/, Promise.all(payloads.map(function (payload) { return _this.sendPayload(payload); }))];
                        case 1:
                            responses = _a.sent();
                            cb && cb(null, responses);
                            return [2 /*return*/, responses];
                        case 2:
                            error_1 = _a.sent();
                            cb && cb(error_1);
                            throw error_1;
                        case 3: return [2 /*return*/];
                    }
                });
            });
        };
        /**
         * Sends the JSON-RPC payload to the node.
         *
         * @method sendPayload
         *
         * @param {JsonRPCRequest} payload
         *
         * @returns {Promise<JsonRPCResponse>}
         */
        EthProvider.prototype.sendPayload = function (payload) {
            return __awaiter(this, void 0, Promise, function () {
                var id, res, json, error_2;
                return __generator(this, function (_a) {
                    switch (_a.label) {
                        case 0:
                            id = payload.id || 9999999;
                            _a.label = 1;
                        case 1:
                            _a.trys.push([1, 12, , 13]);
                            if (!(payload.method === 'eth_accounts')) return [3 /*break*/, 2];
                            // 获取账户
                            return [2 /*return*/, {
                                    jsonrpc: '2.0',
                                    id: id,
                                    result: [window.addressHex],
                                    error: null,
                                }];
                        case 2:
                            if (!(payload.method === 'eth_sendTransaction')) return [3 /*break*/, 4];
                            return [4 /*yield*/, signTransaction(payload)];
                        case 3: return [2 /*return*/, _a.sent()];
                        case 4:
                            if (!(payload.method === 'personal_sign')) return [3 /*break*/, 6];
                            return [4 /*yield*/, signPersonalMessage(payload)];
                        case 5: return [2 /*return*/, _a.sent()];
                        case 6:
                            if (!(payload.method === 'eth_sign')) return [3 /*break*/, 8];
                            return [4 /*yield*/, sign(payload)];
                        case 7: return [2 /*return*/, _a.sent()];
                        case 8: return [4 /*yield*/, fetch(this.host, {
                                method: 'POST',
                                body: JSON.stringify(payload),
                            })];
                        case 9:
                            res = _a.sent();
                            return [4 /*yield*/, res.json()];
                        case 10:
                            json = _a.sent();
                            return [2 /*return*/, json];
                        case 11: return [3 /*break*/, 13];
                        case 12:
                            error_2 = _a.sent();
                            throw error_2;
                        case 13: return [2 /*return*/];
                    }
                });
            });
        };
        EthProvider.prototype.enable = function () {
            return new Promise(function (resolve, reject) {
                resolve([window.addressHex]);
            });
        };
        return EthProvider;
    }());
    var ethereum = new EthProvider(window.rpcURL);
    if (typeof window.Web3 !== 'undefined') {
        window.web3 = new window.Web3(ethereum);
        window.web3.eth.defaultAccount = window.addressHex;
        window.web3.version.getNetwork = function (cb) {
            cb(null, window.chainID);
        };
        window.web3.eth.getCoinbase = function (cb) {
            return cb(null, window.addressHex);
        };
    }

    return ethereum;

}));
//# sourceMappingURL=index.js.map
