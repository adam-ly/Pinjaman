//
//  StringHelper.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/14.
//

import Foundation

enum LocalizeContent {
    // login
    case loginTitle
    case loginSubTitle
    case loginDesc
    case phonenumber
    case phonenumberPlaceholder
    case originCode
    case verifyCode
    case getCode
    case voiceVerification
    case loginPrivacy
    case loginPrivacyContent
    case loginButton
    
    // order
    case orderList
    case orderAll
    case orderApply
    case orderRepayment
    case orderFinished
    case orderEmpty
    
    // Me
    case welcome
    case serviceAndTool
    case uncertifyTitle
    case uncertifyDesc
    case certifyTitle
    case certifyDesc
    
    // product
    case productTips
    case identityInfomation
    case cardPopUpWindowTitle
    case facePopUpWindowTitle
    case cardPopUpTitle
    case cardPopUpDesc
    case cardPopUpContent
    case authentication
    case emergencyContact
    case confirmInfomation
    case confirmInfomationDesc
    
    // logout
    case setup
    case version
    case cancellation
    case logout
    
    // signUp
    case signout
    case signoutAlert
        
    // button
    case confirm
    case next
    case cancel
    case goSetting
    
    // Toast
    case phoneNumberEmpty // 未输入手机号
    case phoneCodeEmpty // 未输入验证码
    case agreement // 勾选协议
    case productAgreement // 产品
    case cancellationAgreement // 注销
    
    // Alert
    case networkDenyTitle
    case locationDenyTitle
    case cameraDenyTitle
    case contactDenyTitle
    case networkDeny // 网络拒绝
    case locationDeny // 定位拒绝
    case cameraDeny // 相机拒绝
    case contactDeny // 通讯录拒绝
    
    func text() -> String {
        switch self {
        // login
        case .loginTitle:
            return isEnglish() ? "Login" : "Masuk"
        case .loginSubTitle:
            return isEnglish() ? "Hello" : "Halo"
        case .loginDesc:
            return isEnglish() ? "Welcome to Pinjaman Hebat" : "Selamat datang di Pinjaman Hebat"
        case .phonenumber:
            return isEnglish() ? "Phone number" : "Nomor telepon"
        case .phonenumberPlaceholder:        
            return isEnglish() ? "Enter your phone number" : "Masukkan nomor telepon Anda"
        case .originCode:
            return isEnglish() ? "+91" : "+62"
        case .verifyCode:
            return isEnglish() ? "Verification code" : "Kode verifikasi"
        case .getCode:
            return isEnglish() ? "Get code" : "Kirim kode"
        case .voiceVerification:
            return isEnglish() ? "Voice verification?" : "Verifikasi suara?"
        case .loginPrivacy:
            return isEnglish() ? "I consent to the" : "Saya menyetujui"
        case .loginPrivacyContent:
            return  isEnglish() ? "<Privacy policy>" : "<Kebijakan privasi>"
        case .loginButton:
            return isEnglish() ? "Log in" : "Masuk"
        
        // order
        case .orderList:
            return isEnglish() ? "Order List" : "Daftar Pesanan"
        case .orderAll:
            return isEnglish() ? "All" : "Semua"
        case .orderApply:
            return isEnglish() ? "Apply" : "Menerapkan"
        case .orderRepayment:
            return isEnglish() ? "Repayment" : "Pembayaran"
        case .orderFinished:
            return isEnglish() ? "Finished" : "Dilunasi"
        case .orderEmpty:
            return isEnglish() ? "No more records" : "Tidak ada lagi rekaman."
            
        // Me
        case .welcome:
            return isEnglish() ? "Welcome to " : "Selamat Datang di "
        case .serviceAndTool:
            return isEnglish() ? "Services & Tools" : "Layanan & Alat"
        case .uncertifyTitle:
            return isEnglish() ? "No Certified" : "Tidak Bersertifikat"
        case .uncertifyDesc:
            return isEnglish() ? "Get a loan through certification" : "Dapatkan pinjaman melalui sertifikasi"
        case .certifyTitle:
            return isEnglish() ? "Certified" : "Bersertifikat"
        case .certifyDesc:
            return isEnglish() ? "You have been certified and qualified for the loan" : "Anda telah disertifikasi dan memenuhi syarat untuk pinjaman tersebut"
            
            // product
        case .productTips:
            return isEnglish() ? "Please fill in your personal data (don't worry, your information and data are protected)" :
            "Silakan isi data pribadi Anda (jangan khawatir, informasi dan data Anda dilindungi)"
        case .identityInfomation:
            return isEnglish() ? "Identity information" : "Verifikasi identitas"
        case .cardPopUpWindowTitle:
            return isEnglish() ? "PAN Card Front" : "Pengenalan Wajah"
        case .facePopUpWindowTitle:
            return isEnglish() ? "Face recognition" : "Verifikasi identitas"
        case .cardPopUpTitle:
            return isEnglish() ? "Correct demonstration" : "Demonstrasi yang benar"
        case .cardPopUpDesc:
            return isEnglish() ? "Error sample" : "Contoh kesalahan"
        case .cardPopUpContent:
            return isEnglish() ? "*Please submit the certification according to the sample to avoid blurring, obstructions and reflections" : "*Harap kirimkan sertifikasi sesuai contoh untuk menghindari kabur, halangan dan pantulan"
        case .authentication:
            return isEnglish() ? "Authentication Security" : "Keamanan Autentikasi"
        case .emergencyContact:
            return isEnglish() ? "Emergency contact" : "Kontak Darurat"
        case .confirmInfomation:
            return isEnglish() ? "Confirm information" : "Konfirmasi Informasi"
        case .confirmInfomationDesc:
            return isEnglish() ? "*Check identity information and make sure it is true after sending it cannot be changed!" : "Periksa informasi identitas dan pastikan sudah benar setelah dikirim tidak dapat diubah!"
            
        // log out
        case .setup:
            return isEnglish() ? "Set up" : "Mendirikan"
        case .version:
            return isEnglish() ? "Version" : "Versi"
        case .cancellation:
            return isEnglish() ? "Account cancellation" : "Pembatalan akun"
        case .logout:
            return isEnglish() ? "Logout" : "Keluar"
            
        // button
        case .confirm:
            return isEnglish() ? "Confirm" : "Mengonfirmasi"
        case .next:
            return isEnglish() ? "Next" : "Berikutnya"
            
        case .signout:
            return isEnglish() ? "Sign out" : "Keluar"
        case .signoutAlert:
            return isEnglish() ? "Are you sure you want to exit the application?" : "Apakah Anda yakin ingin keluar dari aplikasi?"
            
        case .cancel:
            return isEnglish() ? "Cancel" : "Batal"
        case .goSetting:
            return isEnglish() ? "Setting" : "Pengaturan"
            
            // toast
        case .phoneNumberEmpty: //未输入手机号
            return isEnglish() ? "Please enter your phone number" : "Silakan masukkan nomor telepon Anda"
        case .phoneCodeEmpty: // 未输入验证码
            return isEnglish() ? "Please enter the verification code" : "Silakan masukkan kode verifikasi"
        case .agreement:
            return isEnglish() ? "Please read and agree to the Privacy Policy" : "Harap membaca dan menyetujui kebijakan privasi"
        case .productAgreement: // 产品
            return isEnglish() ? "Please read and agree to the loan agreement carefully" : "Harap baca dan setujui perjanjian pinjaman dengan saksama."
        case .cancellationAgreement: // 注销
            return isEnglish() ? "Please read and agree to the above content" : "Silakan baca dan setuju dengan hal di atas."
            
            // alert
        case .networkDenyTitle:
            return isEnglish() ? "Network permissions are off" : "Izin jaringan dimatikan"
        case .locationDenyTitle:
            return isEnglish() ? "Location permissions are off" : "Izin lokasi dimatikan"
        case .cameraDenyTitle:
            return isEnglish() ? "Camera permissions are off" : "Izin kamera dimatikan"
        case .contactDenyTitle:
            return isEnglish() ? "Contacts permissions are off" : "Izin kontak dimatikan"
        case .networkDeny:
            return isEnglish() ?
            "we requires internet access to load content and keep your data synced.please go to Settings > Privacy > Location Services, select our app, and turn on location access" :
            "Aplikasi memerlukan akses internet untuk memuat konten dan menyinkronkan data Anda. Silakan buka Pengaturan > Privasi > Layanan Lokasi, pilih aplikasi kami, dan aktifkan akses lokasi"
        case .locationDeny:
            return isEnglish() ? 
            "Location permission is disabled. To regain full functionality, please go to Settings > Privacy > Location Services, select our app, and turn on location access." :
            "Izin lokasi dinonaktifkan. Untuk mengembalikan fungsionalitas penuh, silakan buka Pengaturan > Privasi > Layanan Lokasi, pilih aplikasi kami, dan aktifkan akses lokasi."
        case .cameraDeny:
            return isEnglish() ? 
            "Camera permission is currently denied. To continue using these features, please open Settings > Privacy > Camera, locate our app, and enable camera access." :
            "Izin kamera saat ini ditolak. Untuk terus menggunakan fitur ini, silakan buka Pengaturan > Privasi > Kamera, temukan aplikasi kami, dan aktifkan akses kamera."
        case .contactDeny:
            return isEnglish() ? 
            "Contacts permission is denied. To unlock inviting and sharing features, please navigate to Settings > Privacy > Contacts, select our app, and allow access." :
            "Izin kontak ditolak. Untuk membuka kunci fitur undangan dan berbagi, silakan buka Pengaturan > Privasi > Kontak, pilih aplikasi kami, dan izinkan akses."
        default:
            return ""
        }        
    }
    
    
    private func isEnglish() -> Bool {
        return AppSettings.shared.configModal?.filesniff == 1
    }
}
