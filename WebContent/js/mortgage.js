(function() {
	
	var app = angular.module('mortgage', []);
	
	app.controller('PanelController', function() {
		this.tab = 1;
		
		this.selectTab = function(setTab) {
			this.tab = setTab;
		};
		
		this.isSelected = function(checkTab) {
			return this.tab === checkTab;
		};
	});
	
	app.controller('MortgageController', function($scope, dataService){
		this.takeHomePay = +0;
		this.frequency = +24;
		this.listPrice = +0;
		this.closingCosts = +0;
		this.loanAmount = +this.listPrice * (1 + (this.closingCosts/100));
		this.loanRate = +3.92;
		this.loanTerm = +30;
		
		var r = this.loanRate/100/12;
		var n = this.loanTerm * 12;
		var p = this.loanAmount;
		
		this.monthlyPayment = (r*p*Math.pow((1+r),n))/(Math.pow((1+r),n)-1);
		this.monthlyPayment = +this.monthlyPayment.toFixed(2);
		dataService.monthlyPayment = this.monthlyPayment;
		this.salary = this.takeHomePay * +this.frequency;
		this.percentMonthlyTakehome = 0;
		this.percentMonthlyTakehome = +this.percentMonthlyTakehome.toFixed(1);
		this.savingsMonths = +3;
		this.savingsNeeded = this.monthlyPayment * this.savingsMonths;
		this.savingsNeeded = +this.savingsNeeded.toFixed(2);
		
		this.isSelected = function(inValue) {
			return this.frequency === inValue;
		};
		
		this.calcLoanAmount = function() {
			this.salary = salary.value;
			var costPerc = (this.closingCosts/100);
			var mult = 1 + costPerc;
			this.loanAmount = +this.listPrice * mult;
			this.calcMonthlyPayment();
		};
		
		this.calcMonthlyPayment = function() {
			r = (this.loanRate/100/12);
			n = (this.loanTerm * 12);
			p = this.loanAmount;
			var top = r*p*Math.pow((1+r),n);
			var bottom = Math.pow((1+r),n)-1;
			this.monthlyPayment = top/bottom;
			this.monthlyPayment = +this.monthlyPayment.toFixed(2);
			dataService.monthlyPayment = this.monthlyPayment;
			this.calcPercentMonthlyTakehome();
			this.calcSavings();
		};
		
		this.calcPercentMonthlyTakehome = function() {
			this.salary = salary.value;
			this.percentMonthlyTakehome = +((dataService.monthlyPayment/(this.salary/12))*100).toFixed(1);
			if (this.percentMonthlyTakehome = "NaN") {
				this.percentMonthlyTakehome = 0;
			}
			$('#percentMonthlyTakehome').val(this.percentMonthlyTakehome).trigger('input');
		}
		
		this.calcSalary = function() {
			var check = this.takeHomePay;
			var freq = this.frequency;
			this.salary = +check * freq;
			$('#salary').val(this.salary).trigger('input');
			dataService.salary = this.salary;
			this.calcPercentMonthlyTakehome();
			if (dataService.savingsFunctions !== null) {
				dataService.calcAccounts();
			}
		};
		
		this.calcSavings = function() {
			this.savingsNeeded = this.monthlyPayment * this.savingsMonths;
			this.savingsNeeded = +this.savingsNeeded.toFixed(2);
		};
		
		this.calcSalary();
		
	});
	
	app.controller('SavingsController', function($scope, dataService){
		this.accounts = dataService.accounts;
		this.calcAccounts = dataService.calcAccounts;
		this.calcSpending = dataService.calcSpending;
	});
	
	//Service to share salary between controllers
	app.service('dataService', function() {

	  // private variable
	  var _salary = 0;
	  var _savingsFunctions;
	  var _monthlyPayment = 0;
	  var _accounts;

	  // public API
	  this.salary = _salary;
	  this.savingsFunctions = _savingsFunctions;
	  this.monthlyPayment = _monthlyPayment;
	  

	  this.accounts = [
            { 
			 	name: 'Savings', 
				balance: 4500,
				percent: 'false',
				annualContrib: 100,
				rate: 1,
				projection: 0
			 },
			 {
			 	name: '401k',
				balance: 12000,
				percent: 'true',
				annualContrib: 0,
				rate: 1,
				projection: 0
			 },
			 {
			 	name: 'IRA',
				balance: 0,
				percent: 'false',
				annualContrib: 1000,
				rate: 4,
				projection: 0
		     }
		 ];
		

		this.years = ['2045','2046','2047','2048','2049','2050','2051','2052','2053','2054','2055','2056','2057','2058','2059','2060'];
		this.year = '2050';
		this.sinceRetirement = 1;
		this.spendingRate = 0;
		this.siRatio = 0;
		
		this.calcAccounts = function(){
			console.log("Calculating savings functions.");
			for (var i = 0; i < this.accounts.length; i++) {
				var S;
				if (this.accounts[i].percent === 'true') {
					var salary = this.salary;
					S = salary * (this.accounts[i].annualContrib/100);
				}
				else {
					S = this.accounts[i].annualContrib;
				}
				var r = this.accounts[i].rate/100;
				var t1 = this.year
				var t2 = new Date().getFullYear();
				var t = t1 - t2;
				
				var V = Math.pow(Math.E,(r*t));
				V = V - 1;
				V = V * (S / r);
				V = V + this.accounts[i].balance * Math.pow(Math.E, ((this.accounts[i].rate/100) * t));
				V = V.toFixed(2);
				
				this.accounts[i].projection = V;
			}
			this.calcSpending(this.accounts);
		};
		
		this.calcSpending = function(accounts) {
			var C = 0;
			for (var i = 0; i < this.accounts.length; i++) {
				var top = (this.accounts[i].rate/100) * this.accounts[i].projection;
				var bottom = (1 - Math.pow(Math.E, (-this.accounts[i].rate * this.sinceRetirement)));
				C = C + (top/bottom);
			}
			this.spendingRate = C.toFixed(2);
			this.calcSIRatio();
		};
		
		this.calcSIRatio = function() {
			var sum = 0;
			for (var i = 0; i < this.accounts.length; i++) {
				sum = sum + parseInt(this.accounts[i].projection);
			}
			ratio = sum / this.salary;
			this.siRatio = ratio.toFixed(3);
		};
		
		//Initial calls to calculate default values.
		this.calcAccounts();
		this.calcSpending();
		this.calcSIRatio();
	});
	
})();
