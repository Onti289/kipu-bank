# kipu-bank
Una descripción de lo que hace el contrato.
El contrato lleva los saldos de los usuarios del banco, permitiéndoles depositar y retirar ETH.

Instrucciones de despliegue.
En este caso el despliegue del contrato se hizo desde la IDE Remix en su versión web, realizando los siguientes pasos:
* Hacer click en la pestaña de Deploy & run transactions.
* En ENVIRONMENT seleccionar WalletConnect (en este caso se utilizó MetaMask, se debe tener una cuenta y tiene que estar vinculada con Remix, si no lo está seguir los pasos que salgan en pantalla para hacerlo), arriba a la izquierda Choose Network y luego Sepolia, ya que se está realizando en una red de prueba.
* En ACCOUNT seleccionar la cuenta de la que se debitará el ETH para realizar el deploy.
* En GAS LIMIT seleccionar Estimated Gas
* En CONTRACT seleccionar el archivo del contrato KipuBank ya compilado.
* En DEPLOY, asignar los valores de _threshold (umbral fijo de retiro máximo por transacción) y _bankCap (límite global de ETH depositado en el banco) y luego hacer click en transact.
* Se abrirá MetaMask pidiendo la confirmación ya que se debitará ETH de su cuenta, seleccionar Confirmar y esperar a recibir la notificación de Transacción confirmada.

Cómo interactuar con el contrato.
* Ingresar al siguiente link, donde se muestra el contrato desplegado: https://sepolia.etherscan.io/address/0xa985602104d4db2e5df59562e198d2caec522e4c
* Hacer click en la pestaña Contract
  Surgirán tres opciones, Code, Read Contract y Write Contract;
  Code: Se puede ver el código fuente del contrato.
  Read Contract: Le proporciona todas las funciones del contrato con las que puede obtener resultados del banco o las cuentas de los distintos clientes.
  Write Contract: Le proporciona las funciones para Depositar (depositEth) o retirar (withdrawEth) ETH en la cuenta.
