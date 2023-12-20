[![Build status](https://build.appcenter.ms/v0.1/apps/406058d9-dfe8-4d69-881f-f57ecdf9955c/branches/main/badge)](https://appcenter.ms)

# SiBook 📚📗
## Deskripsi Singkat
Sebuah platform yang dirancang dengan tujuan untuk meningkatkan tingkat literasi di Indonesia. Situs web ini memungkinkan pengguna untuk mencari buku yang mereka inginkan dan meminjam buku secara online. Selain itu, situs ini memberikan kemudahan dalam melacak riwayat peminjaman dan pengembalian buku, serta memberikan pengguna kesempatan untuk memberikan ulasan saat mengembalikan buku. Fitur tambahan yang tersedia adalah kemampuan untuk memfavoritkan buku dari daftar buku yang ada.

## Latar Belakang 
Platform ini muncul sebagai solusi terhadap tantangan yang dihadapi dalam upaya meningkatkan literasi di Indonesia. Di tengah kendala akses terbatas ke perpustakaan fisik, keterbatasan waktu, dan kesulitan mencari buku yang diinginkan, platform ini hadir untuk memberikan akses yang lebih mudah dan praktis sehingga pengguna hanya perlu datang untuk mengambil buku yang sudah direservasi sebelumnya.

Dengan adanya  platform ini, masyarakat Indonesia diharapkan dapat lebih mudah mengakses buku-buku berkualitas, meningkatkan minat membaca, dan memperluas pengetahuan mereka. Fitur pengembalian buku yang melibatkan ulasan buku juga diharapkan dapat memicu diskusi, berbagi pandangan tentang literatur, dan memperkaya pengalaman membaca bagi pengguna. Dengan demikian, platform ini bukan hanya alat praktis dalam mendukung literasi, tetapi juga sebagai medium untuk memperkaya budaya literasi di Indonesia.

## Sumber Dataset Katalog Buku
Kelompok kami mengambil dataset buku dari [Google Books API](https://developers.google.com/books/) yang memiliki kumpulan buku dengan beragam kategori, penulis, maupun jenis buku. Banyaknya variasi dalam jenis buku diharapkan dapat membantu pengguna agar memiliki banyak opsi dalam peminjaman buku.

## Daftar Modul/Fitur
Berikut merupakan daftar modul yang akan diimplementasikan beserta pengembang dari modul tersebut
- Autentikasi User dan Katalog Buku - [Adrian Aryaputra Hamzah](https://github.com/mnqrt)
- Peminjaman Buku - [Gabriella Naomi Hutagalung](https://github.com/gnh374) 
- Pengembalian dan Pengulasan Buku - [Muhammad Hilmy Abdul Aziz](https://github.com/Hilmy224)
- Favoritkan Buku - [Reza Apriono](https://github.com/rzapriono)
- About Us dan Donasi Buku  - [Fernanda Nadhiftya Putra](https://github.com/adipppp)

##  Otorisasi 
### Pengguna yang belum login dapat:
- Melihat katalog buku yang ada
- Mengakses halaman `about us`
- Melihat buku yang sudah diulas

### Pengguna yang sudah login dapat:
- Mengakses seluruh fitur dari user yang tidak login
- Mengubah deskripsi buku berdasarkan id
- Melakukan peminjaman buku sekaligus melihat kumpulan buku yang telah dipinjam
- Melakukan request buku yang belum ada.
- Melakukan pengembalian buku serta mengulas buku
- Memfavoritkan buku sekaligus melihat kumpulan buku yang telah difavoritkan
- Mendonasikan buku

## Anggota Kelompok
Berikut merupakan anggota kelompok beserta pengembang proyek SiBook
- [Adrian Aryaputra Hamzah](https://github.com/mnqrt) - 2206811474 
- [Fernanda Nadhiftya Putra](https://github.com/adipppp) - 2206081686
- [Gabriella Naomi Hutagalung](https://github.com/gnh374) -  2206081616
- [Muhammad Hilmy Abdul Aziz](https://github.com/Hilmy224) - 2206828701
- [Reza Apriono](https://github.com/rzapriono) - 2206827945

## 🌐 Integrasi Web 🌐
Kelompok kami melakukan integrasi website dengan membentuk sebuah fungsi fetching (contoh: untuk login, mengambil list product) yang mengembalikan objek `Future` secara asinkronus dari website SiBook yang telah kami buat pada [tugas sebelumnya](https://sibook-d08-tk.pbp.cs.ui.ac.id/). Untuk mempermudah implementasi autentikasi dan otorisasi, kelompok kami menggunakan library `pbp_django_auth` yang telah disediakan oleh Tim Pengembang PBP. Dengan ini, aplikasi flutter yang kami kembangkan dapat berinteraksi dengan endpoint pada PaaS kelompok kami sebelumnya sehingga data pada flutter dan django dapat tersinkronisasi. 

Untuk memulai aplikasi, dapat dilakukan command `git clone` pada terminal, kemudian `flutter pub get`, setelahnya lakukan `flutter run -d chrome --web-renderer html` untuk dapat melihat hasil aplikasi flutter pada chrome.

## Berita Acara
Dapat diakses melalui spreadsheet [berita acara](https://docs.google.com/spreadsheets/d/1ZFUkqwQGc-nZMWq-vbccy1NEYtcODBSn/edit#gid=842285077).

## Tautan APK
APK SiBook Mobile dapat diakses melalui Microsoft App Center [SiBook Mobile](https://install.appcenter.ms/orgs/sibook/apps/sibook-mobile/distribution_groups/public)
