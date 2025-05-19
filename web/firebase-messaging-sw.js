importScripts('https://www.gstatic.com/firebasejs/10.11.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.11.0/firebase-messaging-compat.js');

firebase.initializeApp({
    apiKey: "AIzaSyA2dJ5lcirbOOrO8BtHmnG0Uu5OkKJcs4g",
    authDomain: "minibuddy-456409.firebaseapp.com",
    projectId: "minibuddy-456409",
    storageBucket: "minibuddy-456409.firebasestorage.app",
    messagingSenderId: "1011133607958",
    appId: "1:1011133607958:web:04659c54442c4ac8ab8537",
});

const messaging = firebase.messaging();
