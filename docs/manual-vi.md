# Window Resize — Hướng dẫn sử dụng

## Mục lục

1. [Thiết lập ban đầu](#thiết-lập-ban-đầu)
2. [Đổi kích thước cửa sổ](#đổi-kích-thước-cửa-sổ)
3. [Cài đặt](#cài-đặt)
4. [Khắc phục sự cố](#khắc-phục-sự-cố)

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
3. Tất cả cửa sổ đang mở được liệt kê dưới dạng **[Tên ứng dụng] Tiêu đề cửa sổ**.
4. Di chuột qua một cửa sổ để xem các kích thước đặt sẵn có sẵn.
5. Nhấp vào một kích thước để đổi kích thước cửa sổ ngay lập tức.

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

### Ảnh chụp màn hình

Bật **"Chụp ảnh sau khi thay đổi kích thước"** để tự động chụp cửa sổ sau khi đổi kích thước.

Khi được bật, các tùy chọn sau có sẵn:

- **Lưu vào tệp** — Lưu ảnh chụp màn hình dưới dạng tệp PNG. Khi được bật, chọn vị trí lưu:
  - **Màn hình chính** — Lưu vào thư mục Màn hình chính.
  - **Hình ảnh** — Lưu vào thư mục Hình ảnh.
- **Sao chép vào bảng nhớ tạm** — Sao chép ảnh chụp màn hình vào bảng nhớ tạm để dán vào các ứng dụng khác.

Cả hai tùy chọn có thể được bật độc lập. Ví dụ, bạn có thể sao chép vào bảng nhớ tạm mà không cần lưu vào tệp.

> **Lưu ý:** Tính năng chụp ảnh màn hình yêu cầu quyền **Ghi màn hình**. Khi bạn sử dụng tính năng này lần đầu tiên, macOS sẽ yêu cầu bạn cấp quyền trong **Cài đặt hệ thống > Quyền riêng tư & Bảo mật > Ghi màn hình**.

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
