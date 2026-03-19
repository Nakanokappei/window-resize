# Window Resize — Hướng dẫn sử dụng

## Mục lục

1. [Thiết lập ban đầu](#thiết-lập-ban-đầu)
2. [Snap Resize](#snap-resize)
3. [Cài đặt](#cài-đặt)
4. [Khắc phục sự cố](#khắc-phục-sự-cố)

---

## Thiết lập ban đầu

### Cấp quyền Trợ năng

Window Resize sử dụng API Trợ năng của macOS để phát hiện và đổi kích thước cửa sổ. Bạn cần cấp quyền khi khởi chạy ứng dụng lần đầu tiên.

1. Khởi chạy **Window Resize**. Hộp thoại hệ thống sẽ xuất hiện yêu cầu bạn cấp quyền truy cập Trợ năng.
2. Nhấp **"Mở Cài đặt"** (hoặc đi thủ công đến **Cài đặt hệ thống > Quyền riêng tư & Bảo mật > Trợ năng**).
3. Tìm **"Window Resize"** trong danh sách và bật công tắc.
4. Quay lại ứng dụng — biểu tượng thanh menu sẽ xuất hiện và ứng dụng đã sẵn sàng sử dụng.

> **Lưu ý:** Nếu hộp thoại không xuất hiện, bạn có thể mở cài đặt Trợ năng trực tiếp từ cửa sổ Cài đặt của ứng dụng (xem [Trạng thái Trợ năng](#trạng-thái-trợ-năng)).

---

## Snap Resize

### Cách hoạt động

Window Resize theo dõi thao tác đổi kích thước cửa sổ theo thời gian thực. Khi bạn kéo cạnh hoặc góc cửa sổ để đổi kích thước, ứng dụng phát hiện mức độ gần của kích thước cửa sổ với bất kỳ kích thước đặt sẵn nào.

1. **Bắt đầu đổi kích thước** — kéo cạnh hoặc góc của bất kỳ cửa sổ nào như bình thường.
2. **Lớp phủ xuất hiện** — khi kích thước cửa sổ gần với một kích thước đặt sẵn (trong phạm vi 30 pixel), đường viền màu sẽ xuất hiện xung quanh cửa sổ, hiển thị kích thước đặt sẵn mục tiêu.
3. **Thả để snap** — thả chuột và cửa sổ sẽ tự động khớp chính xác với kích thước đặt sẵn.
4. **Hủy bỏ** — nếu bạn di chuyển kích thước cửa sổ ra xa khỏi kích thước đặt sẵn trước khi thả, lớp phủ sẽ biến mất và không có snap nào xảy ra.

### Hiển thị tỷ lệ khung hình

Trong quá trình đổi kích thước, tỷ lệ khung hình hiện tại được hiển thị trong lớp phủ. Khi tỷ lệ khớp với một tỷ lệ nổi tiếng, tên của nó sẽ được hiển thị:

- **Tỷ lệ vàng** (1.618:1)
- **Tỷ lệ bạc** (2.414:1)
- **Tỷ lệ bạch kim** (1.325:1)
- **Tỷ lệ đồng** (3.303:1)

Các tỷ lệ khác được hiển thị dưới dạng phân số rút gọn (ví dụ: "16:9", "4:3").

> Tính năng này có thể tắt trong Cài đặt (xem [Hiển thị tỷ lệ khung hình](#giao-diện-lớp-phủ)).

### Giữ Shift để khóa tỷ lệ khung hình

Giữ phím **Shift** trong khi đổi kích thước để khóa tỷ lệ khung hình. Cửa sổ sẽ giữ nguyên tỷ lệ hiện tại khi bạn kéo.

> Tính năng này có thể tắt trong Cài đặt (xem [Giữ Shift để khóa tỷ lệ](#giao-diện-lớp-phủ)).

---

## Cài đặt

Mở Cài đặt từ thanh menu: nhấp biểu tượng Window Resize, sau đó chọn **"Cài đặt..."** (phím tắt: **Cmd+,**).

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
3. Kích thước mới có sẵn ngay lập tức để phát hiện snap trong quá trình đổi kích thước.

Để xóa một kích thước tùy chỉnh, nhấp nút **"Xóa"** màu đỏ bên cạnh nó.

### Giao diện lớp phủ

Cấu hình kiểu hiển thị của lớp phủ snap:

- **Đường viền đổi kích thước** — màu đường viền và kiểu đường (liền hoặc nét đứt) hiển thị khi đổi kích thước gần với kích thước đặt sẵn. Mặc định: cam, nét đứt.
- **Đường viền snap** — màu đường viền và kiểu đường hiển thị khi cửa sổ khớp với kích thước đặt sẵn. Mặc định: cam, liền.
- **Hiển thị tỷ lệ khung hình** — bật/tắt nhãn tỷ lệ khung hình trong lớp phủ. Mặc định: bật.
- **Giữ Shift để khóa tỷ lệ** — bật/tắt tính năng giữ Shift để cố định tỷ lệ khung hình trong khi đổi kích thước. Mặc định: bật.

Các màu đường viền có sẵn: Cam, Xanh dương, Xanh lá, Đỏ, Tím, Trắng.

### Khởi chạy khi đăng nhập

Bật **"Khởi chạy khi đăng nhập"** để Window Resize tự động khởi động khi bạn đăng nhập vào macOS.

### Ngôn ngữ

Chọn ngôn ngữ hiển thị của ứng dụng từ menu thả xuống **Ngôn ngữ**. Bạn có thể chọn từ 16 ngôn ngữ hoặc **"Mặc định hệ thống"** để theo ngôn ngữ hệ thống macOS. Thay đổi ngôn ngữ yêu cầu khởi động lại ứng dụng.

### Trạng thái Trợ năng

Ở cuối cửa sổ Cài đặt, chỉ báo trạng thái hiển thị tình trạng hiện tại của quyền Trợ năng:

| Chỉ báo | Ý nghĩa |
|---------|---------|
| Xanh lá | Quyền đang hoạt động và hoạt động bình thường. |
| Cam | Hệ thống báo cáo quyền đã được cấp, nhưng không còn hiệu lực (xem [Sửa quyền đã hết hạn](#sửa-quyền-đã-hết-hạn)). Nút **"Mở Cài đặt"** được hiển thị. |
| Đỏ | Quyền chưa được cấp. Nút **"Mở Cài đặt"** được hiển thị. |

---

## Khắc phục sự cố

### Sửa quyền đã hết hạn

Nếu bạn thấy chỉ báo trạng thái màu cam hoặc thông báo "Trợ năng: Cần làm mới", quyền đã hết hạn. Điều này có thể xảy ra sau khi ứng dụng được cập nhật hoặc build lại.

**Cách sửa:**

1. Mở **Cài đặt hệ thống > Quyền riêng tư & Bảo mật > Trợ năng**.
2. Tìm **"Window Resize"** trong danh sách.
3. **Tắt** công tắc, sau đó **bật** lại.
4. Hoặc xóa hoàn toàn khỏi danh sách, sau đó khởi chạy lại ứng dụng để thêm lại.

### Snap không hoạt động

Nếu lớp phủ không xuất hiện trong quá trình đổi kích thước:

- Kiểm tra quyền Trợ năng đang hoạt động (chỉ báo xanh lá trong Cài đặt).
- Đảm bảo cửa sổ bạn đang đổi kích thước hỗ trợ đổi kích thước tiêu chuẩn (một số ứng dụng hạn chế kích thước cửa sổ).
- Cửa sổ toàn màn hình không thể đổi kích thước — thoát toàn màn hình trước.

### Lỗi hiển thị cửa sổ sau khi snap

Trong một số trường hợp hiếm, cửa sổ mục tiêu có thể không vẽ lại đúng sau khi snap. Ứng dụng tự động buộc vẽ lại, nhưng nếu lỗi hiển thị vẫn còn, hãy thử thu nhỏ và khôi phục cửa sổ.
