// Code generated by protoc-gen-gogo. DO NOT EDIT.
// source: pylons/pylons/google_iap_order.proto

package types

import (
	fmt "fmt"
	proto "github.com/gogo/protobuf/proto"
	io "io"
	math "math"
	math_bits "math/bits"
)

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

// This is a compile-time assertion to ensure that this generated file
// is compatible with the proto package it is being compiled against.
// A compilation error at this line likely means your copy of the
// proto package needs to be updated.
const _ = proto.GoGoProtoPackageIsVersion3 // please upgrade the proto package

type GoogleInAppPurchaseOrder struct {
	Creator           string `protobuf:"bytes,1,opt,name=creator,proto3" json:"creator,omitempty"`
	ProductId         string `protobuf:"bytes,2,opt,name=product_id,json=productId,proto3" json:"product_id,omitempty"`
	PurchaseToken     string `protobuf:"bytes,3,opt,name=purchase_token,json=purchaseToken,proto3" json:"purchase_token,omitempty"`
	ReceiptDataBase64 string `protobuf:"bytes,4,opt,name=receipt_data_base64,json=receiptDataBase64,proto3" json:"receipt_data_base64,omitempty"`
	Signature         string `protobuf:"bytes,5,opt,name=signature,proto3" json:"signature,omitempty"`
}

func (m *GoogleInAppPurchaseOrder) Reset()         { *m = GoogleInAppPurchaseOrder{} }
func (m *GoogleInAppPurchaseOrder) String() string { return proto.CompactTextString(m) }
func (*GoogleInAppPurchaseOrder) ProtoMessage()    {}
func (*GoogleInAppPurchaseOrder) Descriptor() ([]byte, []int) {
	return fileDescriptor_4732ff89897d2627, []int{0}
}
func (m *GoogleInAppPurchaseOrder) XXX_Unmarshal(b []byte) error {
	return m.Unmarshal(b)
}
func (m *GoogleInAppPurchaseOrder) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	if deterministic {
		return xxx_messageInfo_GoogleInAppPurchaseOrder.Marshal(b, m, deterministic)
	} else {
		b = b[:cap(b)]
		n, err := m.MarshalToSizedBuffer(b)
		if err != nil {
			return nil, err
		}
		return b[:n], nil
	}
}
func (m *GoogleInAppPurchaseOrder) XXX_Merge(src proto.Message) {
	xxx_messageInfo_GoogleInAppPurchaseOrder.Merge(m, src)
}
func (m *GoogleInAppPurchaseOrder) XXX_Size() int {
	return m.Size()
}
func (m *GoogleInAppPurchaseOrder) XXX_DiscardUnknown() {
	xxx_messageInfo_GoogleInAppPurchaseOrder.DiscardUnknown(m)
}

var xxx_messageInfo_GoogleInAppPurchaseOrder proto.InternalMessageInfo

func (m *GoogleInAppPurchaseOrder) GetCreator() string {
	if m != nil {
		return m.Creator
	}
	return ""
}

func (m *GoogleInAppPurchaseOrder) GetProductId() string {
	if m != nil {
		return m.ProductId
	}
	return ""
}

func (m *GoogleInAppPurchaseOrder) GetPurchaseToken() string {
	if m != nil {
		return m.PurchaseToken
	}
	return ""
}

func (m *GoogleInAppPurchaseOrder) GetReceiptDataBase64() string {
	if m != nil {
		return m.ReceiptDataBase64
	}
	return ""
}

func (m *GoogleInAppPurchaseOrder) GetSignature() string {
	if m != nil {
		return m.Signature
	}
	return ""
}

func init() {
	proto.RegisterType((*GoogleInAppPurchaseOrder)(nil), "pylons.pylons.GoogleInAppPurchaseOrder")
}

func init() {
	proto.RegisterFile("pylons/pylons/google_iap_order.proto", fileDescriptor_4732ff89897d2627)
}

var fileDescriptor_4732ff89897d2627 = []byte{
	// 269 bytes of a gzipped FileDescriptorProto
	0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0xff, 0x3c, 0x90, 0xcd, 0x4a, 0xf4, 0x30,
	0x14, 0x86, 0x9b, 0xef, 0xf3, 0x87, 0x06, 0x46, 0x30, 0x6e, 0xb2, 0xd0, 0x20, 0xa2, 0xe0, 0x42,
	0x3b, 0x0b, 0xc5, 0xbd, 0x83, 0x28, 0xb3, 0x72, 0x10, 0x57, 0x6e, 0x42, 0x9a, 0x1e, 0xda, 0xe2,
	0xd8, 0x13, 0xd2, 0x53, 0x70, 0xee, 0xc2, 0xcb, 0x9a, 0xe5, 0x2c, 0x5d, 0x4a, 0x7b, 0x23, 0x32,
	0x69, 0xeb, 0xea, 0x24, 0xcf, 0xf3, 0x26, 0x21, 0x2f, 0x3f, 0x77, 0xab, 0x25, 0x56, 0xf5, 0x74,
	0x18, 0x39, 0x62, 0xbe, 0x04, 0x5d, 0x1a, 0xa7, 0xd1, 0x67, 0xe0, 0x13, 0xe7, 0x91, 0x50, 0x4c,
	0x7a, 0x9d, 0xf4, 0xe3, 0x6c, 0xcd, 0xb8, 0x7c, 0x0a, 0xc9, 0x79, 0x75, 0xef, 0xdc, 0xa2, 0xf1,
	0xb6, 0x30, 0x35, 0x3c, 0x6f, 0x4f, 0x08, 0xc9, 0xf7, 0xad, 0x07, 0x43, 0xe8, 0x25, 0x3b, 0x65,
	0x97, 0xf1, 0xcb, 0xb8, 0x15, 0x27, 0x9c, 0x3b, 0x8f, 0x59, 0x63, 0x49, 0x97, 0x99, 0xfc, 0x17,
	0x64, 0x3c, 0x90, 0x79, 0x26, 0x2e, 0xf8, 0x81, 0x1b, 0x6e, 0xd2, 0x84, 0xef, 0x50, 0xc9, 0xff,
	0x21, 0x32, 0x19, 0xe9, 0xeb, 0x16, 0x8a, 0x84, 0x1f, 0x79, 0xb0, 0x50, 0x3a, 0xd2, 0x99, 0x21,
	0xa3, 0x53, 0x53, 0xc3, 0xdd, 0xad, 0xdc, 0x09, 0xd9, 0xc3, 0x41, 0x3d, 0x18, 0x32, 0xb3, 0x20,
	0xc4, 0x31, 0x8f, 0xeb, 0x32, 0xaf, 0x0c, 0x35, 0x1e, 0xe4, 0x6e, 0xff, 0xe8, 0x1f, 0x98, 0x3d,
	0xae, 0x5b, 0xc5, 0x36, 0xad, 0x62, 0x3f, 0xad, 0x62, 0x5f, 0x9d, 0x8a, 0x36, 0x9d, 0x8a, 0xbe,
	0x3b, 0x15, 0xbd, 0x5d, 0xe5, 0x25, 0x15, 0x4d, 0x9a, 0x58, 0xfc, 0x98, 0x2e, 0xc2, 0xbf, 0xaf,
	0x09, 0x6c, 0x31, 0x36, 0xf5, 0x39, 0x2e, 0x68, 0xe5, 0xa0, 0x4e, 0xf7, 0x42, 0x51, 0x37, 0xbf,
	0x01, 0x00, 0x00, 0xff, 0xff, 0xab, 0x0f, 0x66, 0x46, 0x50, 0x01, 0x00, 0x00,
}

func (m *GoogleInAppPurchaseOrder) Marshal() (dAtA []byte, err error) {
	size := m.Size()
	dAtA = make([]byte, size)
	n, err := m.MarshalToSizedBuffer(dAtA[:size])
	if err != nil {
		return nil, err
	}
	return dAtA[:n], nil
}

func (m *GoogleInAppPurchaseOrder) MarshalTo(dAtA []byte) (int, error) {
	size := m.Size()
	return m.MarshalToSizedBuffer(dAtA[:size])
}

func (m *GoogleInAppPurchaseOrder) MarshalToSizedBuffer(dAtA []byte) (int, error) {
	i := len(dAtA)
	_ = i
	var l int
	_ = l
	if len(m.Signature) > 0 {
		i -= len(m.Signature)
		copy(dAtA[i:], m.Signature)
		i = encodeVarintGoogleIapOrder(dAtA, i, uint64(len(m.Signature)))
		i--
		dAtA[i] = 0x2a
	}
	if len(m.ReceiptDataBase64) > 0 {
		i -= len(m.ReceiptDataBase64)
		copy(dAtA[i:], m.ReceiptDataBase64)
		i = encodeVarintGoogleIapOrder(dAtA, i, uint64(len(m.ReceiptDataBase64)))
		i--
		dAtA[i] = 0x22
	}
	if len(m.PurchaseToken) > 0 {
		i -= len(m.PurchaseToken)
		copy(dAtA[i:], m.PurchaseToken)
		i = encodeVarintGoogleIapOrder(dAtA, i, uint64(len(m.PurchaseToken)))
		i--
		dAtA[i] = 0x1a
	}
	if len(m.ProductId) > 0 {
		i -= len(m.ProductId)
		copy(dAtA[i:], m.ProductId)
		i = encodeVarintGoogleIapOrder(dAtA, i, uint64(len(m.ProductId)))
		i--
		dAtA[i] = 0x12
	}
	if len(m.Creator) > 0 {
		i -= len(m.Creator)
		copy(dAtA[i:], m.Creator)
		i = encodeVarintGoogleIapOrder(dAtA, i, uint64(len(m.Creator)))
		i--
		dAtA[i] = 0xa
	}
	return len(dAtA) - i, nil
}

func encodeVarintGoogleIapOrder(dAtA []byte, offset int, v uint64) int {
	offset -= sovGoogleIapOrder(v)
	base := offset
	for v >= 1<<7 {
		dAtA[offset] = uint8(v&0x7f | 0x80)
		v >>= 7
		offset++
	}
	dAtA[offset] = uint8(v)
	return base
}
func (m *GoogleInAppPurchaseOrder) Size() (n int) {
	if m == nil {
		return 0
	}
	var l int
	_ = l
	l = len(m.Creator)
	if l > 0 {
		n += 1 + l + sovGoogleIapOrder(uint64(l))
	}
	l = len(m.ProductId)
	if l > 0 {
		n += 1 + l + sovGoogleIapOrder(uint64(l))
	}
	l = len(m.PurchaseToken)
	if l > 0 {
		n += 1 + l + sovGoogleIapOrder(uint64(l))
	}
	l = len(m.ReceiptDataBase64)
	if l > 0 {
		n += 1 + l + sovGoogleIapOrder(uint64(l))
	}
	l = len(m.Signature)
	if l > 0 {
		n += 1 + l + sovGoogleIapOrder(uint64(l))
	}
	return n
}

func sovGoogleIapOrder(x uint64) (n int) {
	return (math_bits.Len64(x|1) + 6) / 7
}
func sozGoogleIapOrder(x uint64) (n int) {
	return sovGoogleIapOrder(uint64((x << 1) ^ uint64((int64(x) >> 63))))
}
func (m *GoogleInAppPurchaseOrder) Unmarshal(dAtA []byte) error {
	l := len(dAtA)
	iNdEx := 0
	for iNdEx < l {
		preIndex := iNdEx
		var wire uint64
		for shift := uint(0); ; shift += 7 {
			if shift >= 64 {
				return ErrIntOverflowGoogleIapOrder
			}
			if iNdEx >= l {
				return io.ErrUnexpectedEOF
			}
			b := dAtA[iNdEx]
			iNdEx++
			wire |= uint64(b&0x7F) << shift
			if b < 0x80 {
				break
			}
		}
		fieldNum := int32(wire >> 3)
		wireType := int(wire & 0x7)
		if wireType == 4 {
			return fmt.Errorf("proto: GoogleInAppPurchaseOrder: wiretype end group for non-group")
		}
		if fieldNum <= 0 {
			return fmt.Errorf("proto: GoogleInAppPurchaseOrder: illegal tag %d (wire type %d)", fieldNum, wire)
		}
		switch fieldNum {
		case 1:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field Creator", wireType)
			}
			var stringLen uint64
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowGoogleIapOrder
				}
				if iNdEx >= l {
					return io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				stringLen |= uint64(b&0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			intStringLen := int(stringLen)
			if intStringLen < 0 {
				return ErrInvalidLengthGoogleIapOrder
			}
			postIndex := iNdEx + intStringLen
			if postIndex < 0 {
				return ErrInvalidLengthGoogleIapOrder
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			m.Creator = string(dAtA[iNdEx:postIndex])
			iNdEx = postIndex
		case 2:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field ProductId", wireType)
			}
			var stringLen uint64
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowGoogleIapOrder
				}
				if iNdEx >= l {
					return io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				stringLen |= uint64(b&0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			intStringLen := int(stringLen)
			if intStringLen < 0 {
				return ErrInvalidLengthGoogleIapOrder
			}
			postIndex := iNdEx + intStringLen
			if postIndex < 0 {
				return ErrInvalidLengthGoogleIapOrder
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			m.ProductId = string(dAtA[iNdEx:postIndex])
			iNdEx = postIndex
		case 3:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field PurchaseToken", wireType)
			}
			var stringLen uint64
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowGoogleIapOrder
				}
				if iNdEx >= l {
					return io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				stringLen |= uint64(b&0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			intStringLen := int(stringLen)
			if intStringLen < 0 {
				return ErrInvalidLengthGoogleIapOrder
			}
			postIndex := iNdEx + intStringLen
			if postIndex < 0 {
				return ErrInvalidLengthGoogleIapOrder
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			m.PurchaseToken = string(dAtA[iNdEx:postIndex])
			iNdEx = postIndex
		case 4:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field ReceiptDataBase64", wireType)
			}
			var stringLen uint64
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowGoogleIapOrder
				}
				if iNdEx >= l {
					return io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				stringLen |= uint64(b&0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			intStringLen := int(stringLen)
			if intStringLen < 0 {
				return ErrInvalidLengthGoogleIapOrder
			}
			postIndex := iNdEx + intStringLen
			if postIndex < 0 {
				return ErrInvalidLengthGoogleIapOrder
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			m.ReceiptDataBase64 = string(dAtA[iNdEx:postIndex])
			iNdEx = postIndex
		case 5:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field Signature", wireType)
			}
			var stringLen uint64
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowGoogleIapOrder
				}
				if iNdEx >= l {
					return io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				stringLen |= uint64(b&0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			intStringLen := int(stringLen)
			if intStringLen < 0 {
				return ErrInvalidLengthGoogleIapOrder
			}
			postIndex := iNdEx + intStringLen
			if postIndex < 0 {
				return ErrInvalidLengthGoogleIapOrder
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			m.Signature = string(dAtA[iNdEx:postIndex])
			iNdEx = postIndex
		default:
			iNdEx = preIndex
			skippy, err := skipGoogleIapOrder(dAtA[iNdEx:])
			if err != nil {
				return err
			}
			if (skippy < 0) || (iNdEx+skippy) < 0 {
				return ErrInvalidLengthGoogleIapOrder
			}
			if (iNdEx + skippy) > l {
				return io.ErrUnexpectedEOF
			}
			iNdEx += skippy
		}
	}

	if iNdEx > l {
		return io.ErrUnexpectedEOF
	}
	return nil
}
func skipGoogleIapOrder(dAtA []byte) (n int, err error) {
	l := len(dAtA)
	iNdEx := 0
	depth := 0
	for iNdEx < l {
		var wire uint64
		for shift := uint(0); ; shift += 7 {
			if shift >= 64 {
				return 0, ErrIntOverflowGoogleIapOrder
			}
			if iNdEx >= l {
				return 0, io.ErrUnexpectedEOF
			}
			b := dAtA[iNdEx]
			iNdEx++
			wire |= (uint64(b) & 0x7F) << shift
			if b < 0x80 {
				break
			}
		}
		wireType := int(wire & 0x7)
		switch wireType {
		case 0:
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return 0, ErrIntOverflowGoogleIapOrder
				}
				if iNdEx >= l {
					return 0, io.ErrUnexpectedEOF
				}
				iNdEx++
				if dAtA[iNdEx-1] < 0x80 {
					break
				}
			}
		case 1:
			iNdEx += 8
		case 2:
			var length int
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return 0, ErrIntOverflowGoogleIapOrder
				}
				if iNdEx >= l {
					return 0, io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				length |= (int(b) & 0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			if length < 0 {
				return 0, ErrInvalidLengthGoogleIapOrder
			}
			iNdEx += length
		case 3:
			depth++
		case 4:
			if depth == 0 {
				return 0, ErrUnexpectedEndOfGroupGoogleIapOrder
			}
			depth--
		case 5:
			iNdEx += 4
		default:
			return 0, fmt.Errorf("proto: illegal wireType %d", wireType)
		}
		if iNdEx < 0 {
			return 0, ErrInvalidLengthGoogleIapOrder
		}
		if depth == 0 {
			return iNdEx, nil
		}
	}
	return 0, io.ErrUnexpectedEOF
}

var (
	ErrInvalidLengthGoogleIapOrder        = fmt.Errorf("proto: negative length found during unmarshaling")
	ErrIntOverflowGoogleIapOrder          = fmt.Errorf("proto: integer overflow")
	ErrUnexpectedEndOfGroupGoogleIapOrder = fmt.Errorf("proto: unexpected end of group")
)
