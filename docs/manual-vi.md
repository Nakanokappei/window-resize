# Window Resize — Hướng dẫn sử dụng

## Mục lục

1. [Thiết lập ban đầu](#thiết-lập-ban-đầu)
2. [Đổi kích thước cửa sổ](#đổi-kích-thước-cửa-sổ)
3. [Cài đặt](#cài-đặt)
4. [Tính năng hỗ trợ tiếp cận](#tính-năng-hỗ-trợ-tiếp-cận)
5. [Khắc phục sự cố](#khắc-phục-sự-cố)

---

## Thiết lập ban đầu

### Cấp quyền Trợ năng

Window Resize sử dụng API Trợ năng của macOS để đổi kích thước cửa sổ. Bạn cần cấp quyền khi khởi chạy ứng dụng lần đầu tiên.

1. Khởi chạy **Window Resize**. Hộp thoại hệ thống sẽ xuất hiện yêu cầu bạn cấp quyền truy cập Trợ năng.
2. Nhấp **"Mở Cài đặt"** (hoặc đi thủ công đến **Cài đặt hệ thống > Quyền riêng tư & Bảo mật > Trợ năng**).
3. Tìm **"Window Resize"** trong danh sách và bật công tắc.
4. Quay lại ứng dụng — biểu tượng thanh menu sẽ xuất hiện và ứng dụng đã sẵn sàng sử dụng.

> **Lưu ý:** Nếu hộp thoại không xuất hiện, bạn có thể mở cài đặt Trợ năng trực tiếp từ cửa sổ Cài đặt của ứng dụng (xem [Trạng thái Trợ năng](#trạng-thái-trợ-năng)).

---

## Đổi kích thước cửa sổ

### Hướng dẫn từng bước

1. Nhấp **biểu tượng Window Resize** trên thanh menu.
2. Di chuột qua **"Đổi kích thước"** để mở danh sách cửa sổ.
3. Tất cả cửa sổ đang mở được hiển thị với **biểu tượng ứng dụng** và tên dưới dạng **[Tên ứng dụng] Tiêu đề cửa sổ**. Các tiêu đề dài sẽ được tự động rút gọn để giữ cho menu dễ đọc.
4. Khi một ứng dụng có **3 cửa sổ trở lên**, chúng sẽ được tự động gom nhóm dưới tên ứng dụng (ví dụ: **"Safari (4)"**). Di chuột qua tên ứng dụng để xem từng cửa sổ, sau đó di chuột qua cửa sổ để xem các kích thước.
5. Di chuột qua một cửa sổ để xem các kích thước đặt sẵn có sẵn.
6. Nhấp vào một kích thước để đổi kích thước cửa sổ ngay lập tức.

### Cách hiển thị kích thước

Mỗi mục kích thước trong menu hiển thị:

```
1920 x 1080          Full HD
```

- **Bên trái:** Rộng x Cao (tính bằng pixel)
- **Bên phải:** Nhãn (tên thiết bị hoặc tên tiêu chuẩn), hiển thị bằng màu xám

### Kích thước vượt quá màn hình

Nếu một kích thước đặt sẵn lớn hơn màn hình nơi cửa sổ đang hiển thị, kích thước đó sẽ **bị làm mờ và không thể chọn**. Điều này ngăn bạn đổi kích thước cửa sổ vượt ra ngoài ranh giới màn hình.

> **Nhiều màn hình:** Ứng dụng phát hiện cửa sổ đang ở màn hình nào và tự động điều chỉnh các kích thước có sẵn cho phù hợp.

---

## Cài đặt

Mở Cài đặt từ thanh menu: nhấp biểu tượng Window Resize, sau đó chọn **"Cài đặt..."** (phím tắt: **⌘,**).

### Kích thước có sẵn

Ứng dụng bao gồm 12 kích thước đặt sẵn có sẵn:

| Kích thước | Nhãn |
|------------|------|
| 2560 x 1600 | MacBook Pro 16" |
| 2560 x 1440 | QHD / iMac |
| 1728 x 1117 | MacBook Pro 14" |
| 1512 x 982 | MacBook Air 15" |
| 1470 x 956 | MacBook Air 13" M3 |
| 1440 x 900 | MacBook Air 13" |
| 1920 x 1080 | Full HD |
| 1680 x 1050 | WSXGA+ |
| 1280 x 800 | WXGA |
| 1280 x 720 | HD |
| 1024 x 768 | XGA |
| 800 x 600 | SVGA |

Kích thước có sẵn không thể xóa hoặc chỉnh sửa.

### Kích thước tùy chỉnh

Bạn có thể thêm kích thước của riêng mình vào danh sách:

1. Trong phần **"Tùy chỉnh"**, nhập **Rộng** và **Cao** tính bằng pixel.
2. Nhấp **"Thêm"**.
3. Kích thước mới xuất hiện trong danh sách tùy chỉnh và có sẵn ngay trong menu đổi kích thước.

Để xóa một kích thước tùy chỉnh, nhấp nút **"Xóa"** màu đỏ bên cạnh nó.

> Kích thước tùy chỉnh xuất hiện trong menu đổi kích thước sau các kích thước có sẵn.

### Khởi chạy khi đăng nhập

Bật **"Khởi chạy khi đăng nhập"** để Window Resize tự động khởi động khi bạn đăng nhập vào macOS.

---

## Tính năng hỗ trợ tiếp cận

Các tính năng dưới đây giúp cải thiện khả năng tiếp cận khi quản lý cửa sổ. Khi bất kỳ tính năng nào được bật, menu đổi kích thước sẽ hiển thị thêm tùy chọn **"Kích thước hiện tại"** ở đầu danh sách, cho phép bạn di chuyển hoặc đưa cửa sổ lên trước mà không thay đổi kích thước.

### Đưa lên trước

Bật **"Đưa cửa sổ lên trước sau khi đổi kích thước"** để tự động đưa cửa sổ vừa đổi kích thước lên phía trên tất cả các cửa sổ khác. Tính năng này hữu ích khi cửa sổ đích bị che khuất một phần bởi các cửa sổ khác.

### Di chuyển đến màn hình chính

Bật **"Di chuyển đến màn hình chính"** để tự động chuyển cửa sổ sang màn hình chính khi đổi kích thước. Tính năng này tiện lợi trong cấu hình nhiều màn hình khi bạn muốn nhanh chóng đưa cửa sổ từ màn hình phụ sang.

### Vị trí cửa sổ

Chọn vị trí đặt cửa sổ trên màn hình sau khi đổi kích thước. Một dãy 9 nút đại diện cho các vị trí:

- **Góc:** Trên-trái, Trên-phải, Dưới-trái, Dưới-phải
- **Cạnh:** Trên-giữa, Trái-giữa, Phải-giữa, Dưới-giữa
- **Trung tâm:** Giữa màn hình

Nhấp vào một nút vị trí để chọn. Nhấp lại vào nút đó (hoặc nhấp **"Không di chuyển"**) để bỏ chọn. Khi không có vị trí nào được chọn, cửa sổ sẽ giữ nguyên vị trí sau khi đổi kích thước.

> **Lưu ý:** Tính năng đặt vị trí cửa sổ có tính đến thanh menu và Dock, đảm bảo cửa sổ nằm trong vùng màn hình sử dụng được.

---

### Ảnh chụp màn hình

Bật **"Chụp ảnh sau khi thay đổi kích thước"** để tự động chụp cửa sổ sau khi đổi kích thước.

Khi được bật, các tùy chọn sau có sẵn:

- **Lưu vào tệp** — Lưu ảnh chụp màn hình dưới dạng tệp PNG. Nhấp nút **"Chọn..."** để chọn thư mục lưu.
  > **Định dạng tên tệp:** `MMddHHmmss_TênỨngDụng_TiêuĐềCửaSổ.png` (ví dụ: `0227193012_Safari_Apple.png`). Các ký hiệu được loại bỏ; chỉ sử dụng chữ cái, chữ số và dấu gạch dưới.
- **Sao chép vào bảng nhớ tạm** — Sao chép ảnh chụp màn hình vào bảng nhớ tạm để dán vào các ứng dụng khác.

Cả hai tùy chọn có thể được bật độc lập. Ví dụ, bạn có thể sao chép vào bảng nhớ tạm mà không cần lưu vào tệp.

> **Lưu ý:** Tính năng chụp ảnh màn hình yêu cầu quyền **Ghi màn hình**. Khi bạn sử dụng tính năng này lần đầu tiên, macOS sẽ yêu cầu bạn cấp quyền trong **Cài đặt hệ thống > Quyền riêng tư & Bảo mật > Ghi màn hình**.

### Ngôn ngữ

Chọn ngôn ngữ hiển thị của ứng dụng từ menu thả xuống **Ngôn ngữ**. Bạn có thể chọn từ 16 ngôn ngữ hoặc **"Mặc định hệ thống"** để theo ngôn ngữ hệ thống macOS. Thay đổi ngôn ngữ yêu cầu khởi động lại ứng dụng.

### Trạng thái Trợ năng

Ở cuối cửa sổ Cài đặt, chỉ báo trạng thái hiển thị tình trạng hiện tại của quyền Trợ năng:

| Chỉ báo | Ý nghĩa |
|---------|---------|
| 🟢 **Trợ năng: Đã bật** | Quyền đang hoạt động và hoạt động bình thường. |
| 🟠 **Trợ năng: Cần làm mới** | Hệ thống báo cáo quyền đã được cấp, nhưng không còn hiệu lực (xem [Sửa quyền đã hết hạn](#sửa-quyền-đã-hết-hạn)). Nút **"Mở Cài đặt"** được hiển thị. |
| 🔴 **Trợ năng: Chưa bật** | Quyền chưa được cấp. Nút **"Mở Cài đặt"** được hiển thị. |

---

## Khắc phục sự cố

### Sửa quyền đã hết hạn

Nếu bạn thấy chỉ báo trạng thái màu cam hoặc thông báo "Trợ năng: Cần làm mới", quyền đã hết hạn. Điều này có thể xảy ra sau khi ứng dụng được cập nhật hoặc build lại.

**Cách sửa:**

1. Mở **Cài đặt hệ thống > Quyền riêng tư & Bảo mật > Trợ năng**.
2. Tìm **"Window Resize"** trong danh sách.
3. **Tắt** công tắc, sau đó **bật** lại.
4. Hoặc xóa hoàn toàn khỏi danh sách, sau đó khởi chạy lại ứng dụng để thêm lại.

### Đổi kích thước thất bại

Nếu bạn thấy cảnh báo "Đổi kích thước thất bại", các nguyên nhân có thể bao gồm:

- Ứng dụng đích không hỗ trợ đổi kích thước dựa trên Trợ năng.
- Cửa sổ đang ở **chế độ toàn màn hình** (thoát toàn màn hình trước).
- Quyền Trợ năng chưa được kích hoạt (kiểm tra trạng thái trong Cài đặt).

### Cửa sổ không xuất hiện trong danh sách

Menu đổi kích thước chỉ hiển thị các cửa sổ:

- Hiện đang hiển thị trên màn hình
- Không phải một phần của desktop (ví dụ: desktop Finder bị loại trừ)
- Không phải cửa sổ của chính ứng dụng Window Resize

Nếu cửa sổ đã được thu nhỏ xuống Dock, nó sẽ không xuất hiện trong danh sách.

### Ảnh chụp màn hình không hoạt động

Nếu ảnh chụp màn hình không được chụp:

- Cấp quyền **Ghi màn hình** trong **Cài đặt hệ thống > Quyền riêng tư & Bảo mật > Ghi màn hình**.
- Đảm bảo ít nhất một trong hai tùy chọn **"Lưu vào tệp"** hoặc **"Sao chép vào bảng nhớ tạm"** đã được bật.
