(routes => routes({
  dc: {
    nspaces: {
      _options: {
        path: '/namespaces',
        abilities: ['read nspaces'],
      },
      index: {
        _options: {
          path: '/',
          queryParams: {
            sortBy: 'sort',
            searchproperty: {
              as: 'searchproperty',
              empty: [['Name', 'Description', 'Role', 'Policy']],
            },
            search: {
              as: 'filter',
              replace: true,
            },
          },
        },
      },
      edit: {
        _options: { path: '/:name' },
      },
      create: {
        _options: {
          template: '../edit',
          path: '/create',
          abilities: ['create nspaces'],
        },
      },
    },
  },
}))(
  (json, data = document.currentScript.dataset) => {
    const appNameJS = data.appName.split('-')
      .map((item, i) => i ? `${item.substr(0, 1).toUpperCase()}${item.substr(1)}` : item)
      .join('');
    data[`${appNameJS}Routes`] = JSON.stringify(json);
  }
);
