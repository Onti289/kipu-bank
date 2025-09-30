# kipu-bank
Una descripción de lo que hace el contrato.
El contrato lleva los saldos de los usuarios del banco, permitiéndoles depositar y retirar ETH.

Instrucciones de despliegue.
En este caso el despliegue del contrato se hizo desde la IDE Remix en su versión web, realizando los siguientes pasos:
* Hacer click en la pestaña de Deploy & run transactions.
* En ENVIRONMENT seleccionar WalletConnect (en este caso se utilizó MetaMask).
* En ACCOUNT seleccionar la cuenta de la que se debitará el ETH para realizar el deploy.
* En CONTRACT seleccionar el archivo del contrato KipuBank ya compilado.
* En DEPLOY, asignar los valores de _threshold (umbral fijo de retiro máximo por transacción) y _bankCap (límite global de ETH depositado en el banco) y luego hacer click en transact.

Cómo interactuar con el contrato.
