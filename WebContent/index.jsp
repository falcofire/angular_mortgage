<!DOCTYPE html>
<html ng-app="mortgage">
	<title>Personal Finance</title>
	<link rel='stylesheet' href='css/bootstrap.min.css'>
	<link rel='stylesheet' href='css/bootstrap-theme.min.css'>
	<link rel='stylesheet' href='css/mortgage.css'>
	<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.8/angular.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.3/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/mortgage.js"></script>
	<meta name='viewport' content='user-scalable=yes, width=device-width, initial-scale=1'>
	<div ng-controller="PanelController as panel">
		<ul class="nav nav-tabs">
			<li role="presentation" ng-class="{ active:panel.isSelected(1) }"><a href ng-click="panel.selectTab(1)"><h4>Home Buying</h4></a></li>
			<!-- <li role="presentation" ng-class="{ active:panel.isSelected(2) }"><a href ng-click="panel.selectTab(2)"><h4>Savings Projections</h4></a></li> -->
			<div class="pull-right" ng-controller="MortgageController as formCtrl">
				<div class="row" style="padding-top:5px;">
					<h5 class="pull-left hidden-xs">Take Home Pay</h5>
					<input type="hidden" id="salary" value="{{formCtrl.salary}}" ng-model="formCtrl.salary" />
					<div class="form-group col-md-4">
						<input type="number" class="form-control" id="takeHomePay"
							ng-change="formCtrl.calcSalary()" ng-model="formCtrl.takeHomePay"/>
					</div>
					<div class="form-group col-md-4">
						<select class="form-control" id="frequency" ng-change="formCtrl.calcSalary()" ng-model="formCtrl.frequency">
							<option value="1" ng-selected="formCtrl.frequency === 1">Annually</option>
							<option value="12" ng-selected="formCtrl.frequency === 12">Monthly</option>
							<option value="24" ng-selected="formCtrl.frequency === 24">Semi-monthly</option>
							<option value="52" ng-selected="formCtrl.frequency === 52">Weekly</option>
						</select>
					</div>
				</div>
			</div>
		</ul>
		<form class="main-form container-fluid" ng-show="panel.isSelected(1)" ng-controller="MortgageController as formCtrl">
			<!-- HOME DATA -->
			<fieldset>
				<legend><span class="glyphicon glyphicon-home icon"></span>House Data</legend>
				<div class="row">
					<div class="form-group col-md-4">
						<label for="listPrice">List Price</label>
						<div class="input-group">
							<span class="input-group-addon glyphicon glyphicon-usd"></span>
							<input type="number" class="form-control" id="listPrice"
								ng-keyup="formCtrl.calcLoanAmount()" ng-model="formCtrl.listPrice"/>
						</div>
					</div>
					<div class="form-group col-md-4">
						<label for="closingCosts">Closing Costs (%)</label>
						<input type="number" class="form-control" id="closingCosts"
							ng-keyup="formCtrl.calcLoanAmount()" ng-model="formCtrl.closingCosts"/>
					</div>
				</div>
			</fieldset>
			<!-- LOAN DATA -->
			<fieldset>
				<legend><span class="glyphicon glyphicon-credit-card icon"></span>Loan Data</legend>
				<div class="row">
					<div class="form group col-md-4">
						<label for="loanAmount">Loan amount</label>
						<div class="input-group pad-under">
							<span class="input-group-addon glyphicon glyphicon-usd"></span>
							<input type="number" class="form-control" id="loanAmount"
								ng-keyup="formCtrl.calcMonthlyPayment()" ng-model="formCtrl.loanAmount"/>
						</div>
					</div>
					<div class="form-group col-md-2">
						<label for="loanRate">Rate (%)</label>
						<input type="number" class="form-control" id="loanRate"
							ng-keyup="formCtrl.calcMonthlyPayment()" ng-model="formCtrl.loanRate"/>
					</div>
					<div class="form-group col-md-2">
						<label for="loanTerm">Term (years)</label>
						<input type="number" class="form-control" id="loanTerm"
							ng-keyup="formCtrl.calcMonthlyPayment()" ng-model="formCtrl.loanTerm"/>
					</div>
				</div>
				<div class="row">
					<div class="form-group col-md-4">
						<label for="monthlyPayment">Monthly Payment</label>
						<div class="input-group">
							<span class="input-group-addon glyphicon glyphicon-usd"></span>
							<input type="number" class="form-control" id="monthlyPayment"
								ng-model="formCtrl.monthlyPayment"/>
						</div>
					</div>
					<div class="form-group col-md-4">
						<label for="percentMonthlyTakehome">% of monthly takehome</label>
						<input type="number" class="form-control" id="percentMonthlyTakehome" 
							ng-model="formCtrl.percentMonthlyTakehome"/>
					</div>
				</div>
			</fieldset>
			<!-- SAVINGS DATA -->
			<fieldset>
				<legend><span class="glyphicon glyphicon-piggy-bank icon"></span>Savings Data</legend>
				<div class="row">
					<div class="form-group col-md-4">
						<label for="savingsNeeded">{{formCtrl.savingsMonths}} months of mortgage payments</label>
						<div class="input-group">
							<span class="input-group-addon glyphicon glyphicon-usd"></span>
							<input type="number" class="form-control" id="savingsMonths"
								ng-model="formCtrl.savingsNeeded"/>
						</div>
					</div>
					<div class="form-group col-md-4">
						<label for="savingsMonths">Months worth of savings</label>
						<input type="number" class="form-control" id="savingsMonths"
							ng-change="formCtrl.calcSavings()" ng-keyup="formCtrl.calcSavings()" ng-model="formCtrl.savingsMonths"/>
					</div>
				</div>
			</fieldset>
		</form>
		<!--  SAVINGS TAB -->
		<form class="main-form" ng-show="panel.isSelected(2)" ng-controller="SavingsController as savingsCtrl" style="width:80%;">
			<fieldset class="col-md-13">
				<legend>Value of Investments at Retirement</legend>
				<div class="row" ng-repeat="account in savingsCtrl.accounts">
					<div class="form-group col-md-2">
						<label for="{{account.name}}Balance">{{account.name}} Account Initial</label>
						<input class="form-control" id="{{account.name}}Balance" value="{{account.balance}}" 
							ng-change="savingsCtrl.calcAccounts()" ng-model="account.balance" />
					</div>
					<div class="form-group col-md-2">
						<label for="percent">Type</label>
						<select class="form-control" name="percent" id="percent" ng-change="savingsCtrl.calcAccounts()" 
							ng-model="account.percent">
							<option value='true'>% (of salary)</option>
							<option value='false'>$ (fixed amount)</option>
						</select>
					</div>
					<div class="form-group col-md-2">
						<label for="{{account.name}}Annually">Annual Contribution</label>
						<input class="form-control" id="{{account.name}}Annually" value="{{account.annualContrib}}" 
							ng-change="savingsCtrl.calcAccounts()" ng-model="account.annualContrib"/>
					</div>
					<div class="form-group col-md-2">
						<label for="{{account.name}}Return">Rate of Return</label>
						<input class="form-control" id="{{account.name}}Return" value="{{account.rate}}" 
							ng-change="savingsCtrl.calcAccounts()" ng-model="account.rate"/>
					</div>
					<div class="form-group date col-md-2">
						<label for="year">Retirement Year</label>
					    <select class="form-control" name="year" id="year" ng-options="year for year in savingsCtrl.years track by year"
							ng-change="savingsCtrl.calcAccounts()" ng-model="savingsCtrl.year">
						</select>
					</div>
					<div class="pull-right">
						<h3>$ {{account.projection}}</h3>
					</div>
				</div>
			</fieldset>
			<fieldset class="col-md-13">
				<legend>Spending Projections after Retirement</legend>
				<div class="col-md-2">
					<label for="sinceRetirement">Years Since Retirement</label>
					<input class="form-control" id="sinceRetirement" name="sinceRetirement" value="{{savingsCtrl.sinceRetirement}}"
						ng-change="savingsCtrl.calcSpending()" ng-model="savingsCtrl.sinceRetirement" />
				</div>
				<div class="col-md-3">
					<h3>Salary: $ {{savingsCtrl.spendingRate}}</h3>
				</div>
				<div class="col-md-4">
					<h3>Savings to Income Ratio: {{savingsCtrl.siRatio}}</h3>
				</div>
			</fieldset>
		</form>
	</div>
	<footer class="footer">
		<div class="container">
			<p class="text-muted">Formulas derived from <a href="http://onlinelibrary.wiley.com/doi/10.1002/9781118656761.app4/pdf" target="_blank">Wiley</a></p>
		</div>
	</footer>
</html>