export const toolList = {
  left: [{
    label: 'Insert Row Above',
    action: 'insert',
    location: 'previous',
    target: 'row'
  }, {
    label: 'Insert Row Below',
    action: 'insert',
    location: 'next',
    target: 'row'
  }, {
    label: 'Remove Row',
    action: 'remove',
    location: 'current',
    target: 'row'
  }],
  bottom: [{
    label: 'Insert Column Left',
    action: 'insert',
    location: 'left',
    target: 'column'
  }, {
    label: 'Insert Column Right',
    action: 'insert',
    location: 'right',
    target: 'column'
  }, {
    label: 'Remove Column',
    action: 'remove',
    location: 'current',
    target: 'column'
  }, {
    label: '表左对齐',
    action: 'align',
    location: 'left',
    target: 'table'
  }, {
    label: '表居中',
    action: 'align',
    location: 'center',
    target: 'table'
  }, {
    label: '表右对齐',
    action: 'align',
    location: 'right',
    target: 'table'
  }]
}
