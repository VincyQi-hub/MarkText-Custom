import editIcon from '../../assets/pngicon/imageEdit/2.png'
import inlineIcon from '../../assets/pngicon/inline_image/2.png'
import leftIcon from '../../assets/pngicon/algin_left/2.png'
import middleIcon from '../../assets/pngicon/algin_center/2.png'
import rightIcon from '../../assets/pngicon/algin_right/2.png'
import deleteIcon from '../../assets/pngicon/image_delete/2.png'

const icons = [
  {
    type: 'edit',
    tooltip: 'Edit Image',
    icon: editIcon
  },
  {
    type: 'wrap',
    tooltip: '文字环绕',
    icon: inlineIcon
  },
  {
    type: 'left',
    tooltip: '左对齐',
    icon: leftIcon
  },
  {
    type: 'center',
    tooltip: '居中对齐',
    icon: middleIcon
  },
  {
    type: 'right',
    tooltip: '右对齐',
    icon: rightIcon
  },
  {
    type: 'delete',
    tooltip: 'Remove Image',
    icon: deleteIcon
  }
]

export default icons
