/**
 * Created by miki on 2016-06-06.
 */
(function() {
    if('serviceWorker' in navigator) {
        navigator.serviceWorker.register('./service-worker.js').then(function() {
            console.log('here is the worker registration');
        });
    }
})();