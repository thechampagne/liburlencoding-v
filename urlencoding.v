/*
 * Copyright (c) 2022 XXIV
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
module urlencoding

#flag -lurlencoding
fn C.url_encoding_encode(&char) &char
fn C.url_encoding_encode_binary(&char, C.size_t) &char
fn C.url_encoding_decode(&char) &char
fn C.url_encoding_decode_binary(&char, C.size_t) &char
fn C.url_encoding_free(&char)

// Percent-encodes every byte except alphanumerics and -, _, ., ~. Assumes UTF-8 encoding.
// 
// Example:
// * *
// res := urlencoding.encode("This is string will be encoded.")
// println(res)
// * *
// 
// @param data
// @return encoded string
pub fn encode(data string) string {
	res := C.url_encoding_encode(&char(data.str))
	if res == C.NULL {
		return ""
	}
	str := unsafe {cstring_to_vstring(res)}
	C.url_encoding_free(res)
	return str
}

// Percent-encodes every byte except alphanumerics and -, _, ., ~.
// 
// Example:
// * *
// res := urlencoding.encode_binary("This is string will be encoded.")
// println(res)
// * *
// 
// @param data
// @return encoded string
pub fn encode_binary(data string) string {
	res := C.url_encoding_encode_binary(&char(data.str), C.size_t(data.len))
	if res == C.NULL {
		return ""
	}
	str := unsafe {cstring_to_vstring(res)}
	C.url_encoding_free(res)
	return str
}

// Decode percent-encoded string assuming UTF-8 encoding.
// 
// Example:
// * *
// res := urlencoding.decode("%F0%9F%91%BE%20Exterminate%21")
// println(res)
// * *
// 
// @param data
// @return decoded string
pub fn decode(data string) string {
	res := C.url_encoding_decode(&char(data.str))
	if res == C.NULL {
		return ""
	}
	str := unsafe {cstring_to_vstring(res)}
	C.url_encoding_free(res)
	return str
}


// Decode percent-encoded string as binary data, in any encoding.
// 
// Example:
// * *
// res := urlencoding.decode_binary("%F1%F2%F3%C0%C1%C2")
// println(res)
// * *
// 
// @param data
// @return decoded string
pub fn decode_binary(data string) string {
	res := C.url_encoding_decode_binary(&char(data.str), C.size_t(data.len))
	if res == C.NULL {
		return ""
	}
	str := unsafe {cstring_to_vstring(res)}
	C.url_encoding_free(res)
	return str
}