<html>
<head>
    <style type="text/css">
        ${css}

.list_sale_table {
    border:thin solid #E3E4EA;
    text-align:center;
    border-collapse: collapse;
}
.list_sale_table th {
    background-color: #EEEEEE;
    border: thin solid #000000;
    text-align:center;
    font-size:12;
    font-weight:bold;
    padding-right:3px;
    padding-left:3px;
}
.list_sale_table td {
    border-top: thin solid #EEEEEE;
    text-align:left;
    font-size:12;
    padding-right:3px;
    padding-left:3px;
    padding-top:3px;
    padding-bottom:3px;
}
.list_sale_table thead {
    display:table-header-group;
}

td.formatted_note {
    text-align:left;
    border-right:thin solid #EEEEEE;
    border-left:thin solid #EEEEEE;
    border-top:thin solid #EEEEEE;
    padding-left:10px;
    font-size:11;
}



.no_bloc {
    border-top: thin solid  #ffffff ;
}

.right_table {
    right: 4cm;
    width:"100%";
}

.std_text {
    font-size:12;
}

tfoot.totals tr:first-child td{
    padding-top: 15px;
}


td.amount, th.amount {
    text-align: right;
    white-space: nowrap;
}


.address .recipient .shipping .invoice {
    font-size: 12px;
}

.list_bank_table {
    text-align:center;
    border-collapse: collapse;
}
.list_bank_table th {
    background-color: #EEEEEE;
    text-align:left;
    font-size:12;
    font-weight:bold;
    padding-right:3px;
    padding-left:3px;
}
.list_bank_table td {
    text-align:left;
    font-size:12;
    padding-right:3px;
    padding-left:3px;
    padding-top:3px;
    padding-bottom:3px;
}
    </style>
</head>
<body>
    <%page expression_filter="entity"/>
    <%
    def carriage_returns(text):
        return text.replace('\n', '<br />')

    %>
    %for order in objects:
    <% setLang(order.partner_id.lang) %>
    <%
      quotation = order.state in ['draft', 'sent']
    %>
    <div class="address">
        <table class="recipient">
            %if order.partner_id.parent_id:
            <tr><td class="name">${order.partner_id.parent_id.name or ''}</td></tr>
            <tr><td>${order.partner_id.title and order.partner_id.title.name or ''} ${order.partner_id.name }</td></tr>
            <% address_lines = order.partner_id.contact_address.split("\n")[1:] %>
            %else:
            <tr><td class="name">${order.partner_id.title and order.partner_id.title.name or ''} ${order.partner_id.name }</td></tr>
            <% address_lines = order.partner_id.contact_address.split("\n") %>
            %endif
            %for part in address_lines:
                %if part:
                <tr><td>${part}</td></tr>
                %endif
            %endfor
        </table>

    <p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
    <h1 style="clear:both;">${quotation and _(u'Quotation N°') or _(u'Order N°') } ${order.name}</h1>
    
     <table class="basic_table" width="100%">
        <tr>
            <td style="font-weight:bold;">${quotation and _("Quotation Date") or _("Date Ordered")}</td>
            <td style="font-weight:bold;">${ _("Validité") }</td>
            <td style="font-weight:bold;">${_("Salesman")}</td>
            <td style="font-weight:bold;">${_('Payment Term')}</td>
        </tr>
        <tr>
            <td>${formatLang(order.date_order, date=True)}</td>
            <td>1 mois</td>
            <td>${order.user_id and order.user_id.name or ''}</td>
            <td>${order.payment_term and order.payment_term.note or ''}</td>
        </tr>
    </table>

    %if order.note1:
    <div>
        <p class="std_text"> ${order.note1| n} </p>
    </div>
    %endif

    <table class="list_sale_table" width="100%" style="margin-top: 20px;">
        <thead>
            <tr>
                <th>${_("Description")}</th>
                <th colspan="2">${_("Quantity")}</th>
                <th class="amount">${_("Unit Price")}</th>
                <th>${_("VAT")}</th>
                <th class="amount">${_("Price")}</th>
            </tr>
        </thead>
        <tbody>
        %for line in order.order_line:
            <tr class="line">
                <td style="text-align:left; " >${ line.name }</td>
                <td class="amount" style="text-align:right" width="7.5%">${ formatLang(line.product_uos and line.product_uos_qty or line.product_uom_qty) }</td>
                <td style="text-align:left;" width="7.5%">${ line.product_uos and line.product_uos.name or line.product_uom.name }</td>
                <td class="amount" width="8%">${formatLang(line.price_unit)}&nbsp;${order.pricelist_id.currency_id.symbol}</td>
                <td width="9.5%" style="text-align: center;">${ ', '.join([(tax.description or tax.name) + ' %' for tax in line.tax_id]) }</td>
                <td class="amount" width="13%">${formatLang(line.price_subtotal, digits=get_digits(dp='Sale Price'))}&nbsp;${order.pricelist_id.currency_id.symbol}</td>
            </tr>
            %if line.formatted_note:
            <tr>
              <td class="formatted_note" colspan="6" style="border-top: none;">
                ${line.formatted_note| n}
              </td>
            </tr>
            %endif
        %endfor
        </tbody>
        <tfoot class="totals">
            <tr>
                <td colspan="3" style="border-style:none"/>
                <td colspan="2" style="border-style:none; text-align: right;"><b>${_("Net Total:")}</b></td>
                <td class="amount" style="border-style:none">${formatLang(order.amount_untaxed, get_digits(dp='Sale Price'))} ${order.pricelist_id.currency_id.symbol}</td>
            </tr>
            <tr>
                <td colspan="3" style="border-style:none"/>
                <td colspan="2" style="border-style:none; text-align: right;" ><b>${_("Taxes:")}</b></td>
                <td class="amount"style="border-style:none" >${formatLang(order.amount_tax, get_digits(dp='Sale Price'))} ${order.pricelist_id.currency_id.symbol}</td>
            </tr>
            <tr>
                <td colspan="3" style="border-style:none"/>
                <td colspan="2" style="border-style:none; text-align: right;"><b>${_("Total:")}</b></td>
                <td class="amount" style="border-style:none">${formatLang(order.amount_total, get_digits(dp='Sale Price'))} ${order.pricelist_id.currency_id.symbol}</td>
            </tr>
            % if order.payment_term.id == 4:
            <tr>
                <td colspan="3" style="border-style:none"/>
                <td colspan="2" style="border-style:none; text-align: right;"><b>${_("Acompte :")}</b></td>
                <td class="amount" style="border-style:none">${formatLang(order.amount_total*0.3, get_digits(dp='Sale Price'))} ${order.pricelist_id.currency_id.symbol}</td>
            </tr>
            % endif
        </tfoot>
    </table>
    <br/>
    
    %if order.note :
        <p class="std_text">${order.note | carriage_returns}</p>
    %endif
    %if order.note2:
        <p class="std_text">${order.note2 | n}</p>
    %endif

    % if order.payment_term.id == 4:
    <%
      inv_bank = order.company_id.bank_ids[0]
    %>
    <p>Acompte payable à l'acceptation du devis par virement sur le compte bancaire suivant :</p>
    <table class="list_bank_table" >
      <!-- vat value are taken back from commercial id -->
        <tr>
            <th style="width:20%;">${_("Bank")}</th>
            <td style="width:30%;text-align:left;">${inv_bank and inv_bank.bank_name or '-' } </td>
        </tr>
        <tr>
            <th style="width:20%;">${_("IBAN")}</th>
            <td style="width:50%;text-align:left;">${ inv_bank and inv_bank.acc_number or '-' }</td>
        </tr>
        <tr>
            <th width="20%">${_("BIC")}</th>
            <td style="width:30%;">${inv_bank and inv_bank.bank_bic or '-' }</td>
        </tr>
        <tr>
            <th>RIB</th>
            <td>${inv_bank and inv_bank.bank_code or '' } - ${inv_bank and inv_bank.office or '' } - ${inv_bank and inv_bank.rib_acc_number or '' } - ${inv_bank and inv_bank.key or '' }</td>
        </tr>
    </table>
    % endif

    <p>&nbsp;</p><p>&nbsp;</p>
    <table width="100%" style="text-align: center; vertical-align: top;">
        <tr><td width="50%">Mention manuscrite<br/>"Bon pour accord"</td><td width="25%">Date</td><td width="25%">Signature</td></tr>
        <tr><td><br/><br/><br/><br/></td><td></td><td></td></tr>
    </table>

    %endfor
</body>
</html>
