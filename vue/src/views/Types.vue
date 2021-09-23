<template>
	<div>
		<div class="container">
			<SpTypeForm modulePath="Pylonstech.pylons.pylons" moduleType="Cookbook" action="create" id="createCookBook" />

			<SpType modulePath="Pylonstech.pylons.pylons" moduleType="Recipe" />
			<!-- this line is used by starport scaffolding # 4 -->
			<SpType modulePath="Pylons-tech.pylons.pylons" moduleType="Trade"  />
			<SpType modulePath="Pylons-tech.pylons.pylons" moduleType="GooglIAPOrder"  />
		</div>
	</div>
</template>

<script>
export default {
	name: 'Types'
}
</script>
