class TypeID < String
  class UUID < String
    module Base32
      ALPHABET = "0123456789abcdefghjkmnpqrstvwxyz".freeze

      DEC = [
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x01,
        0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0A, 0x0B, 0x0C,
        0x0D, 0x0E, 0x0F, 0x10, 0x11, 0xFF, 0x12, 0x13, 0xFF, 0x14,
        0x15, 0xFF, 0x16, 0x17, 0x18, 0x19, 0x1A, 0xFF, 0x1B, 0x1C,
        0x1D, 0x1E, 0x1F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
      ].freeze

      # @param bytes [Array<Integer>]
      # @return [String]
      def self.encode(bytes)
        encoded = Array.new(26, 0)

        # 10 byte timestamp
        encoded[0] = ALPHABET[(bytes[0]&224)>>5]
        encoded[1] = ALPHABET[bytes[0]&31]
        encoded[2] = ALPHABET[(bytes[1]&248)>>3]
        encoded[3] = ALPHABET[((bytes[1]&7)<<2)|((bytes[2]&192)>>6)]
        encoded[4] = ALPHABET[(bytes[2]&62)>>1]
        encoded[5] = ALPHABET[((bytes[2]&1)<<4)|((bytes[3]&240)>>4)]
        encoded[6] = ALPHABET[((bytes[3]&15)<<1)|((bytes[4]&128)>>7)]
        encoded[7] = ALPHABET[(bytes[4]&124)>>2]
        encoded[8] = ALPHABET[((bytes[4]&3)<<3)|((bytes[5]&224)>>5)]
        encoded[9] = ALPHABET[bytes[5]&31]

        # 16 bytes of entropy
        encoded[10] = ALPHABET[(bytes[6]&248)>>3]
        encoded[11] = ALPHABET[((bytes[6]&7)<<2)|((bytes[7]&192)>>6)]
        encoded[12] = ALPHABET[(bytes[7]&62)>>1]
        encoded[13] = ALPHABET[((bytes[7]&1)<<4)|((bytes[8]&240)>>4)]
        encoded[14] = ALPHABET[((bytes[8]&15)<<1)|((bytes[9]&128)>>7)]
        encoded[15] = ALPHABET[(bytes[9]&124)>>2]
        encoded[16] = ALPHABET[((bytes[9]&3)<<3)|((bytes[10]&224)>>5)]
        encoded[17] = ALPHABET[bytes[10]&31]
        encoded[18] = ALPHABET[(bytes[11]&248)>>3]
        encoded[19] = ALPHABET[((bytes[11]&7)<<2)|((bytes[12]&192)>>6)]
        encoded[20] = ALPHABET[(bytes[12]&62)>>1]
        encoded[21] = ALPHABET[((bytes[12]&1)<<4)|((bytes[13]&240)>>4)]
        encoded[22] = ALPHABET[((bytes[13]&15)<<1)|((bytes[14]&128)>>7)]
        encoded[23] = ALPHABET[(bytes[14]&124)>>2]
        encoded[24] = ALPHABET[((bytes[14]&3)<<3)|((bytes[15]&224)>>5)]
        encoded[25] = ALPHABET[bytes[15]&31]

        encoded.join
      end

      # @param string [String]
      # @return [Array<Integer>]
      def self.decode(string)
        bytes = string.bytes

        raise "invalid length" unless bytes.length == 26
        raise "invalid base32 character" if bytes.any? { |byte| DEC[byte] == 0xFF }

        output = Array.new(16, 0)

        # 6 bytes timestamp (48 bits)
        output[0] = ((DEC[bytes[0]] << 5) | DEC[bytes[1]]) & 0xFF
        output[1] = ((DEC[bytes[2]] << 3) | (DEC[bytes[3]] >> 2)) & 0xFF
        output[2] = ((DEC[bytes[3]] << 6) | (DEC[bytes[4]] << 1) | (DEC[bytes[5]] >> 4)) & 0xFF
        output[3] = ((DEC[bytes[5]] << 4) | (DEC[bytes[6]] >> 1)) & 0xFF
        output[4] = ((DEC[bytes[6]] << 7) | (DEC[bytes[7]] << 2) | (DEC[bytes[8]] >> 3)) & 0xFF
        output[5] = ((DEC[bytes[8]] << 5) | DEC[bytes[9]]) & 0xFF

        # 10 bytes of entropy (80 bits)
        output[6] = ((DEC[bytes[10]] << 3) | (DEC[bytes[11]] >> 2)) & 0xFF
        output[7] = ((DEC[bytes[11]] << 6) | (DEC[bytes[12]] << 1) | (DEC[bytes[13]] >> 4)) & 0xFF
        output[8] = ((DEC[bytes[13]] << 4) | (DEC[bytes[14]] >> 1)) & 0xFF
        output[9] = ((DEC[bytes[14]] << 7) | (DEC[bytes[15]] << 2) | (DEC[bytes[16]] >> 3)) & 0xFF
        output[10] = ((DEC[bytes[16]] << 5) | DEC[bytes[17]]) & 0xFF
        output[11] = ((DEC[bytes[18]] << 3) | DEC[bytes[19]]>>2) & 0xFF
        output[12] = ((DEC[bytes[19]] << 6) | (DEC[bytes[20]] << 1) | (DEC[bytes[21]] >> 4)) & 0xFF
        output[13] = ((DEC[bytes[21]] << 4) | (DEC[bytes[22]] >> 1)) & 0xFF
        output[14] = ((DEC[bytes[22]] << 7) | (DEC[bytes[23]] << 2) | (DEC[bytes[24]] >> 3)) & 0xFF
        output[15] = ((DEC[bytes[24]] << 5) | DEC[bytes[25]]) & 0xFF

        output
      end
    end
  end
end
