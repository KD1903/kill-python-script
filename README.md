kill python process if GPU temperature reaches limit


Run this script while training your deep learning model
your GPU temperature will continuosly reading from nvidia-smi commamd and kill python process which stops training of deep learning model if GPU temperature reaches limit
script will also show temperature in terminal

to change temperature limit, change the number in if condition in script

Script also send system notification, a voice message (need to install espeak)
it also sends telegram message, for that you have to configure your telegram details in yaml file

for more details about telegram message:
https://www.linuxuprising.com/2021/02/get-notifications-on-your-desktop-or.html
