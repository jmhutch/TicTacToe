? my %current_layout = $game->current_layout

<table border="1">
  <tr id="t">
    <td id="tl"><?= $current_layout{tl} || 'tr' ?></td>
    <td id="tc"><?= $current_layout{tc} || 'tc' ?></td>
    <td id="tr"><?= $current_layout{tr} || 'tr' ?></td>
  </tr>
  <tr id="m">
    <td id="bl"><?= $current_layout{ml} || 'ml' ?></td>
    <td id="bc"><?= $current_layout{mc} || 'mc' ?></td>
    <td id="br"><?= $current_layout{mr} || 'mr' ?></td>
  </tr>
  <tr id="b">
    <td id="bl"><?= $current_layout{bl} || 'bl' ?></td>
    <td id="bc"><?= $current_layout{bc} || 'bc' ?></td>
    <td id="br"><?= $current_layout{br} || 'br' ?></td>
  </tr>
</table>
