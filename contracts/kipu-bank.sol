//SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/**
   @title Contrato KipuBank.
   @author Lucas Ontiveros.
   @notice Este contrato es el trabajo final del Módulo 2 - Fundamentos de Solidity, sirve para realizar depósitos y retiros de cuentas.
   @custom:security Este es un contrato educativo y no debe ser usado en producción.
 */

contract KipuBank{
    /*///////////////////////
		Variables
	///////////////////////*/
    ///@notice variable inmutable para almacenar el umbral fijo de retiro máximo por transacción.
    uint256 immutable i_threshold;

    ///@notice variable inmutable para almacenar el límite global de ETH depositado en el banco.
    uint256 immutable i_bankCap;

    ///@notice variable para almacenar el saldo total de ETH del banco.
    uint256 private currentBalance;
    
    ///@notice variable para contar el numero total de depósitos.
    uint256 private countDeposits;

    ///@notice variable para contar el numero total de retiros.
    uint256 private countWithdrawals;

    ///@notice mapping para almacenar el saldo de cada usuario.
	mapping(address user => uint256 amount) public s_balances;
   
    /*///////////////////////
		Events
	///////////////////////*/
    ///@notice evento emitido cuando se recibe un nuevo depósito.
	event KipuBank_DepositReceived(address indexed user, uint256 _amount);
    ///@notice evento emitido cuando se realiza un retiro exitosamente.
    event KipuBank_SuccessfulWithdrawal(address indexed user, uint256 _amount);
    
    /*///////////////////////
		Errors
	///////////////////////*/
    ///@notice error emitido cuando se deposita o retira una cantidad igual 0.
    error KipuBank_WrongAmount(uint256 _amount);
    ///@notice error emitido cuando se intenta retirar un monto mayor al saldo disponible.
    error KipuBank_InsufficientBalance(uint256 _amount);
    ///@notice error emitido cuando se intenta retirar un monto mayor al umbral.
    error KipuBank_ExcessWithdrawal(uint256 threshold);
    ///@notice error emitido cuando se intenta realizar un depósito cuando se ha alcanzado el límite global de depósitos.
    error KipuBank_BankCapReached(uint256 bankCap);
    ///@notice error emitido cuando falla una transferencia.
    error KipuBank_TransferFailed();

    /*///////////////////////
        Modifiers
    ///////////////////////*/
    ///@notice modificador para verificar que el monto a retirar o depositar no sea 0.
    modifier correctAmount(uint256 _amount){
        if (_amount == 0) revert KipuBank_WrongAmount(_amount);
        _;
    }

    ///@notice modificador para verificar que el monto a retirar no sea mayor que el saldo de la cuenta.
    modifier sufficientBalance(uint256 _amount){
        if (s_balances[msg.sender] < _amount) revert KipuBank_InsufficientBalance(_amount);
        _;
    }

    ///@notice modificador para verificar que el monto a retirar no sea mayor que el umbral de retiro.
    modifier withdrawalLimit(uint256 _amount){
        if (_amount > i_threshold) revert KipuBank_ExcessWithdrawal(i_threshold);
        _;
    }

    ///@notice modificador para verificar que no se supere el límite global de depósitos.
    modifier bankCap(){
        if (currentBalance + msg.value > i_bankCap) revert KipuBank_BankCapReached(i_bankCap);
        _;
    }

    /*///////////////////////
		Functions
	///////////////////////*/
    constructor(uint256 _threshold, uint256 _bankCap){
		i_threshold = _threshold;
        i_bankCap = _bankCap;
        currentBalance = 0;
        countDeposits = 0;
        countWithdrawals = 0;
    }

    ///@notice función para recibir ether directamente.
    receive() external payable{
        _deposit();            
    }
    fallback() external payable{}

    /*
		*@notice función externa para depositar ETH en la cuenta.
		*@dev esta función debe llamar a la función privada que se encarga de la lógica del depósito.
	*/
    function depositEth() external payable{
        _deposit();		  
	}

    /*
		*@notice función para retirar ETH de la cuenta.
		*@dev esta función debe restar el valor del retiro al saldo del usuario.
        *@dev esta función debe sumar 1 al total de retiros.
        *@dev esta función debe restar el valor del retiro al saldo del banco.
        *@dev esta función debe transferir el ETH al usuario.
		*@dev esta función debe emitir un evento informando el retiro.
        *@dev esta función debe emitir un error si el importe es erróneo.
        *@dev esta función debe emitir un error si el saldo es insuficiente.
        *@dev esta función debe emitir un error si el importe supera el umbral.
	*/
    function withdrawEth(uint256 _amount) external correctAmount(_amount) withdrawalLimit(_amount) sufficientBalance(_amount){
        s_balances[msg.sender] -= _amount;
        currentBalance -= _amount;
        countWithdrawals += 1;
        emit KipuBank_SuccessfulWithdrawal(msg.sender, _amount);
        _transferETH(msg.sender, _amount);
	}

    /*
		*@notice función para depositar ETH en la cuenta.
		*@dev esta función debe sumar el valor del depósito al saldo del usuario.
        *@dev esta función debe sumar el valor del depósito al saldo del banco.
        *@dev esta función debe sumar 1 al total de depósitos.
		*@dev esta función debe emitir un evento informando el depósito.
        *@dev esta función debe emitir un error si el importe es erróneo.
        *@dev esta función debe emitir un error si se alcanzó el límite global de depósitos.
	*/
    function _deposit() private correctAmount(msg.value) bankCap() {
        s_balances[msg.sender] += msg.value;
        currentBalance += msg.value;
        countDeposits += 1;
        emit KipuBank_DepositReceived(msg.sender, msg.value);
    }

    /*
		*@notice función para transferir ETH al usuario.
        *@dev esta función debe transferir el monto recibido por parámetro al usuario.
        *@dev esta función debe emitir un error y revertir al estado anterior si no pudo realizar la transferencia.
	*/
    function _transferETH(address user, uint256 _amount) private{
        (bool success,) = payable(user).call{value: _amount}("");
        if (!success) revert KipuBank_TransferFailed();
    }

    /*
		*@notice función para ver obtener el saldo de la cuenta ingresada por parámetro.
		*@dev esta función debe retornar el saldo cuenta ingresada por parámetro.
	*/
    function getUserBalance(address user) external view returns (uint256) {
        return s_balances[user];
    }

    /*
		*@notice función para ver obtener la cantidad total de depositos y retiros del banco.
		*@dev esta función debe retornar el numero total de depósitos y retiros del banco.
	*/
    function getTotals() external view returns (uint256 deposits, uint256 withdrawals) {
        return (countDeposits, countWithdrawals);
    }

    /*
		*@notice función para ver obtener el saldo total del banco.
		*@dev esta función debe retornar el saldo total del banco.
	*/
    function getBankBalance() external view returns (uint256) {
        return currentBalance;
    }
}