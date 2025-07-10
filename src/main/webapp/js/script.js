// JavaScript tùy chỉnh nếu cần
document.addEventListener('DOMContentLoaded', function() {
    console.log('Script loaded');

    // Tự động ẩn alert sau 2 giây
    setTimeout(function() {
        let successAlert = document.getElementById('successAlert');
        if (successAlert) {
            let bootstrapAlert = bootstrap.Alert.getInstance(successAlert);
            if (bootstrapAlert) {
                bootstrapAlert.close();
            } else {
                successAlert.style.display = 'none';
            }
        }
        let errorAlert = document.getElementById('errorAlert');
        if (errorAlert) {
            let bootstrapAlert = bootstrap.Alert.getInstance(errorAlert);
            if (bootstrapAlert) {
                bootstrapAlert.close();
            } else {
                errorAlert.style.display = 'none';
            }
        }
    }, 2000); // 3000 milliseconds = 2 giây
});
