# Window Resize — Huong dan su dung

## Muc luc

1. [Thiet lap ban dau](#thiet-lap-ban-dau)
2. [Snap Resize](#snap-resize)
3. [Phim tat](#phim-tat)
4. [Cai dat](#cai-dat)
5. [Khac phuc su co](#khac-phuc-su-co)

---

## Thiet lap ban dau

### Cap quyen Tro nang

Window Resize su dung API Tro nang cua macOS de phat hien va doi kich thuoc cua so. Ban can cap quyen khi khoi chay ung dung lan dau tien.

1. Khoi chay **Window Resize**. Hop thoai he thong se xuat hien yeu cau ban cap quyen truy cap Tro nang.
2. Nhap **"Open System Settings"** (hoac di thu cong den **System Settings > Privacy & Security > Accessibility**).
3. Tim **"Window Resize"** trong danh sach va bat cong tac.
4. Quay lai ung dung — bieu tuong thanh menu se xuat hien va ung dung da san sang su dung.

> **Luu y:** Neu hop thoai khong xuat hien, ban co the mo cai dat Tro nang truc tiep tu cua so Cai dat cua ung dung (xem [Trang thai Tro nang](#trang-thai-tro-nang)).

---

## Snap Resize

### Cach hoat dong

Window Resize theo doi thao tac doi kich thuoc cua so theo thoi gian thuc. Khi ban keo canh hoac goc cua so de doi kich thuoc, ung dung phat hien muc do gan cua kich thuoc cua so voi bat ky kich thuoc dat san nao.

1. **Bat dau doi kich thuoc** — keo canh hoac goc cua bat ky cua so nao nhu binh thuong.
2. **Lop phu xuat hien** — khi kich thuoc cua so gan voi mot kich thuoc dat san (trong pham vi 30 pixel), duong vien mau se xuat hien xung quanh cua so, hien thi kich thuoc dat san muc tieu.
3. **Tha de snap** — tha chuot va cua so se tu dong khop chinh xac voi kich thuoc dat san.
4. **Huy bo** — neu ban di chuyen kich thuoc cua so ra xa khoi kich thuoc dat san truoc khi tha, lop phu se bien mat va khong co snap nao xay ra.

### Snap khi di chuyen cua so

Keo cua so ve phia canh hoac goc man hinh de snap vao vi tri:

- **Snap canh** (trai/phai) — lap day chieu cao, giu nguyen chieu rong
- **Snap canh** (tren/duoi) — lap day chieu rong, giu nguyen chieu cao
- **Snap goc** — dat cua so vao goc, giu nguyen ca hai chieu

### Hien thi ty le khung hinh

Trong qua trinh doi kich thuoc, ty le khung hinh hien tai duoc hien thi trong lop phu. Khi ty le khop voi mot ty le noi tieng, ten cua no se duoc hien thi:

- **Golden Ratio** (1.618:1)
- **Silver Ratio** (2.414:1)
- **Platinum Ratio** (1.325:1)
- **Bronze Ratio** (3.303:1)

Cac ty le khac duoc hien thi duoi dang phan so rut gon (vi du: "16:9", "4:3").

> Tinh nang nay co the tat trong Cai dat (xem [Tab giao dien](#tab-giao-dien)).

### Giu Shift de khoa ty le khung hinh

Giu phim **Shift** trong khi doi kich thuoc de khoa ty le khung hinh. Cua so se giu nguyen ty le hien tai khi ban keo.

> Tinh nang nay co the tat trong Cai dat (xem [Tab General](#tab-general)).

---

## Phim tat

Tat ca phim tat deu co the tuy chinh trong tab Shortcuts cua Cai dat. Mac dinh:

### Quick Presets

Nhan **Control+Option+1** den **Control+Option+9** de doi kich thuoc cua so phia truoc thanh kich thuoc dat san ngay lap tuc. HUD se hien thi ten va kich thuoc cua preset o giua cua so trong choc lat.

| Phim tat | Preset mac dinh |
|----------|---------------|
| Control+Option+1 | Writing (1280 x 800) |
| Control+Option+2 | Reading (900 x 1200) |
| Control+Option+3 | Browsing (1440 x 900) |
| Control+Option+4 | Sidebar (720 x 900) |
| Control+Option+5 | Preview (1920 x 1080) |

Quick Presets co the chinh sua (ten, kich thuoc va phim tat) trong tab General cua Cai dat. Ho tro toi da 9 presets.

### Doi kich thuoc tung buoc

Doi kich thuoc cua so phia truoc 10 pixel moi lan nhan phim, giu cua so o giua:

| Phim tat | Hanh dong |
|----------|--------|
| Control+Option+Right | Tang chieu rong (+10px) |
| Control+Option+Left | Giam chieu rong (-10px) |
| Control+Option+Up | Tang chieu cao (+10px) |
| Control+Option+Down | Giam chieu cao (-10px) |

### Che do chinh xac

Giu Shift de dieu chinh tung 1 pixel:

| Phim tat | Hanh dong |
|----------|--------|
| Control+Option+Shift+Right | Tang chieu rong (+1px) |
| Control+Option+Shift+Left | Giam chieu rong (-1px) |
| Control+Option+Shift+Up | Tang chieu cao (+1px) |
| Control+Option+Shift+Down | Giam chieu cao (-1px) |

### Hoan tac / Lam lai

| Phim tat | Hanh dong |
|----------|--------|
| Control+Option+Z | Hoan tac doi kich thuoc cuoi |
| Control+Option+Shift+Z | Lam lai |

Moi cua so co lich su hoan tac/lam lai rieng.

### HUD phan hoi

Khi ban su dung phim tat, HUD hinh vien nang se xuat hien o giua cua so muc tieu:

- **Quick Preset:** hien thi ten preset (vi du "Writing") voi kich thuoc ben duoi (vi du "1280 x 800")
- **Doi kich thuoc tung buoc:** hien thi kich thuoc hien tai (vi du "1290 x 800")
- **Hoan tac:** hien thi "Restored" voi kich thuoc da khoi phuc

HUD hien thi trong 0.8 giay, sau do mo dan.

---

## Cai dat

Mo Cai dat tu thanh menu: nhap bieu tuong Window Resize, sau do chon **"Settings..."**.

Cai dat duoc to chuc thanh 4 tab: **General**, **Appearance**, **Shortcuts** va **Presets**.

### Tab General

#### Quick Presets

Cau hinh toi da 9 Quick Presets co the ap dung qua phim tat (Control+Option+1-9). Moi preset bao gom:

- **Phim tat** — nhap vao truong phim tat de ghi to hop phim moi
- **Ten** — ten mo ta (vi du "Writing", "Coding")
- **Kich thuoc** — chieu rong va chieu cao tinh bang pixel

De them preset, dien ten, chieu rong va chieu cao vao cac truong o phia duoi va nhap **"Add"**. De xoa preset, nhap nut X ben canh no.

#### Khoi chay khi dang nhap

Bat **"Launch at Login"** de Window Resize tu dong khoi dong khi ban dang nhap vao macOS.

#### Shift khoa ty le

Bat/tat tinh nang giu Shift de co dinh ty le khung hinh trong khi doi kich thuoc. Mac dinh: bat.

#### Trang thai Tro nang

Chi bao trang thai hien thi tinh trang hien tai cua quyen Tro nang:

| Chi bao | Y nghia |
|---------|---------|
| Xanh la | Quyen dang hoat dong va hoat dong binh thuong. |
| Cam | Quyen da duoc cap nhung het han (xem [Sua quyen da het han](#sua-quyen-da-het-han)). |
| Do | Quyen chua duoc cap. |

### Tab giao dien

Cau hinh kieu hien thi cua lop phu snap:

- **Duong vien doi kich thuoc** — mau duong vien va kieu duong hien thi khi doi kich thuoc. Chon tu 9 mau (do, cam, vang, xanh la, xanh lam nhat, xanh duong, tim, trang, xam) va 4 kieu (khong, lien, net dut, chuyen dong). Mac dinh: trang, chuyen dong.
- **Duong vien snap** — duong vien hien thi khi cua so snap vao preset. Mac dinh: trang, lien.
- **Hien thi ty le khung hinh** — bat/tat nhan ty le khung hinh trong lop phu. Mac dinh: bat.

### Tab phim tat

Tat ca phim tat duoc hien thi trong luoi 2 cot va co the tuy chinh rieng le:

1. Nhap vao truong phim tat ben canh bat ky hanh dong nao.
2. Nhan to hop phim mong muon (phai bao gom it nhat mot phim modifier).
3. Nhan **Escape** de huy ghi.

Neu ban ghi phim tat trung voi hanh dong khac trong ung dung, hop thoai canh bao se xuat hien de chon **Replace** (gan lai phim tat) hoac **Cancel**.

Bieu tuong canh bao se xuat hien ben canh phim tat trung voi phim tat he thong da biet (Mission Control, Spotlight, v.v.).

Nhap **"Reset to Defaults"** de khoi phuc tat ca phim tat ve mac dinh.

### Tab Presets

Tab Presets hien thi 18 kich thuoc preset co san duoc sap xep theo dien tich pixel (nho nhat den lon nhat). Moi preset co cong tac bat/tat:

- **Bat** — preset duoc su dung de phat hien snap trong qua trinh doi kich thuoc
- **Tat** — preset bi loai tru khoi phat hien snap (hien thi o do mo 50%)

Preset co san khong the xoa, chi co the tat. Mac dinh, 6 preset danh rieng cho Mac (kich thuoc man hinh MacBook Air/Pro) bi tat, va 12 preset da dung duoc bat.

Phan dau trang hien thi so preset dang duoc bat (vi du "12 of 18 enabled").

---

## Khac phuc su co

### Sua quyen da het han

Neu ban thay chi bao trang thai mau cam hoac thong bao "Accessibility: Needs Refresh", quyen da het han. Dieu nay co the xay ra sau khi ung dung duoc cap nhat hoac build lai.

**Cach sua:**

1. Mo **System Settings > Privacy & Security > Accessibility**.
2. Tim **"Window Resize"** trong danh sach.
3. **Tat** cong tac, sau do **bat** lai.
4. Hoac xoa hoan toan khoi danh sach, sau do khoi chay lai ung dung de them lai.

### Snap khong hoat dong

Neu lop phu khong xuat hien trong qua trinh doi kich thuoc:

- Kiem tra quyen Tro nang dang hoat dong (chi bao xanh la trong Cai dat).
- Dam bao cua so ban dang doi kich thuoc ho tro doi kich thuoc tieu chuan (mot so ung dung han che kich thuoc cua so).
- Cua so toan man hinh khong the doi kich thuoc — thoat toan man hinh truoc.
- Kiem tra tab Presets — kich thuoc muc tieu co the bi tat.

### Loi hien thi cua so sau khi snap

Trong mot so truong hop hiem, cua so muc tieu co the khong ve lai dung sau khi snap. Ung dung tu dong buoc ve lai, nhung neu loi hien thi van con, hay thu thu nho va khoi phuc cua so.
