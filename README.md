### Instruction Set Architecture (ISA) / Tập lệnh

Trong module điều khiển này, mỗi lệnh có độ dài 8-bit (đầu vào `R_data` hoặc `data_in`), được chia thành 2 phần chính:
* **`[7:4]` (4 bit cao):** Mã lệnh (Main Opcode).
* **`[3:0]` (4 bit thấp):** Dữ liệu tức thời (Immediate - ký hiệu là `Imm`) hoặc các bit dùng để chọn thanh ghi.

Bảng dưới đây mô tả chi tiết các lệnh được hỗ trợ:

| Nhóm lệnh | Mã lệnh (`[7:4]`) | Lệnh | Toán hạng | Opcode ALU | Mô tả hoạt động (RTL) |
| :--- | :---: | :---: | :--- | :---: | :--- |
| **Số học (Arithmetic)** | `0000` | **ADD** | R1, Imm | `00` | `R1 <= R1 + Imm` |
| | `0001` | **SUB** | R1, R0 | `01` | `R1 <= R1 - R0` |
| | `0100` | **SUB** | R0, Imm | `01` | `R0 <= R0 - Imm` |
| | `0010` | **MUL** | Rx, Ry | `10` | `Rx <= Rx * Ry` *(Xem chú thích)* |
| **So sánh (Compare)** | `0101` | **CMP** | R0, Imm | `01` | So sánh `R0` với `Imm` (Chỉ cập nhật cờ, không lưu kết quả) |
| | `0110` | **CMP** | R1, Imm | `01` | So sánh `R1` với `Imm` (Chỉ cập nhật cờ, không lưu kết quả) |
| **Rẽ nhánh (Branch)** | `0111` | **BNE** | Imm | *(Bỏ qua)* | Nếu `zeros_flag == 0`, nhảy tới địa chỉ `Imm` (`R_addr_next = Imm`) |
| **Di chuyển (Move)** | `1100` | **MOV** | R0, Imm | *(Bỏ qua)* | `R0 <= Imm` |
| | `1101` | **MOV** | R1, Imm | *(Bỏ qua)* | `R1 <= Imm` |
| | `1110` | **MOV** | R2, Imm | *(Bỏ qua)* | `R2 <= Imm` |
| | `1111` | **MOV** | R3, Imm | *(Bỏ qua)* | `R3 <= Imm` |

**📌 Chú thích thêm:**
* **Đối với lệnh MUL (`0010`):** Thanh ghi không được gán cố định.
  * Toán hạng `Rx` (thanh ghi đích và toán hạng 1) được định tuyến bởi 2 bit `R_data[3:2]`.
  * Toán hạng `Ry` (toán hạng 2) được định tuyến bởi 2 bit `R_data[1:0]`.
  * *Mã chọn thanh ghi:* `00` -> R0, `01` -> R1, `10` -> R2, `11` -> R3.
* **Đối với các lệnh BNE và MOV:** Module điều khiển không sử dụng ALU để tính toán kết quả, thay vào đó ghi trực tiếp dữ liệu (hoặc cập nhật địa chỉ) ở sườn lên của xung clock tiếp theo.
