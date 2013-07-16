<html>
<head>
    <style type="text/css">
        ${css}

.list_invoice_table {
    border:thin solid #E3E4EA;
    text-align:center;
    border-collapse: collapse;
}
.list_invoice_table th {
    background-color: #EEEEEE;
    border: thin solid #000000;
    text-align:center;
    font-size:12;
    font-weight:bold;
    padding-right:3px;
    padding-left:3px;
}
.list_invoice_table td {
    border-top : thin solid #EEEEEE;
    text-align:left;
    font-size:12;
    padding-right:3px;
    padding-left:3px;
    padding-top:3px;
    padding-bottom:3px;
}
.list_invoice_table thead {
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


.list_tax_table {
}
.list_tax_table td {
    text-align:left;
    font-size:12;
}
.list_tax_table th {
}
.list_tax_table thead {
    display:table-header-group;
}


.list_total_table {
    border:thin solid #E3E4EA;
    text-align:center;
    border-collapse: collapse;
}
.list_total_table td {
    border-top : thin solid #EEEEEE;
    text-align:left;
    font-size:12;
    padding-right:3px;
    padding-left:3px;
    padding-top:3px;
    padding-bottom:3px;
}
.list_total_table th {
    background-color: #EEEEEE;
    border: thin solid #000000;
    text-align:center;
    font-size:12;
    font-weight:bold;
    padding-right:3px
    padding-left:3px
}
.list_total_table thead {
    display:table-header-group;
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

th.date {
    width: 90px;
}

td.amount, th.amount {
    text-align: right;
    white-space: nowrap;
}
.header_table {
    text-align: center;
    border: 1px solid lightGrey;
    border-collapse: collapse;
}
.header_table th {
    font-size: 12px;
    border: 1px solid lightGrey;
}
.header_table td {
    font-size: 12px;
    border: 1px solid lightGrey;
}

td.date {
    white-space: nowrap;
    width: 90px;
}

td.vat {
    white-space: nowrap;
}
.address .recipient {
    font-size: 12px;
}

    </style>
</head>
<body>
    <%page expression_filter="entity"/>
    <%
    def carriage_returns(text):
        return text.replace('\n', '<br />')
    %>

    %for inv in objects:
    <% setLang(inv.partner_id.lang) %>
    <div class="address">
      %if hasattr(inv, 'commercial_partner_id'):
        <table class="recipient">
            %if inv.partner_id.id != inv.commercial_partner_id.id:
            <tr><td class="name">${inv.commercial_partner_id.name or ''}</td></tr>
            <tr><td>${inv.partner_id.title and inv.partner_id.title.name or ''} ${inv.partner_id.name }</td></tr>
            %else:
            <tr><td class="name">${inv.partner_id.title and inv.partner_id.title.name or ''} ${inv.partner_id.name }</td></tr>
            %endif
            %if inv.partner_id.parent_id:
            <% address_lines = inv.partner_id.contact_address.split("\n")[1:] %>
            %else:
            <% address_lines = inv.partner_id.contact_address.split("\n") %>
            %endif
            %for part in address_lines:
                %if part:
                <tr><td>${part}</td></tr>
                %endif
            %endfor
        </table>
      %else:
        <table class="recipient">
            %if inv.partner_id.parent_id:
            <tr><td class="name">${inv.partner_id.parent_id.name or ''}</td></tr>
            <tr><td>${inv.partner_id.title and inv.partner_id.title.name or ''} ${inv.partner_id.name }</td></tr>
            <% address_lines = inv.partner_id.contact_address.split("\n")[1:] %>
            %else:
            <tr><td class="name">${inv.partner_id.title and inv.partner_id.title.name or ''} ${inv.partner_id.name }</td></tr>
            <% address_lines = inv.partner_id.contact_address.split("\n") %>
            %endif
            %for part in address_lines:
                %if part:
                <tr><td>${part}</td></tr>
                %endif
            %endfor
        </table>
      %endif
    </div>
    <h1 style="clear: both; padding-top: 20px;">
        %if inv.type == 'out_invoice' and inv.state == 'proforma2':
            ${_("PRO-FORMA")}
        %elif inv.type == 'out_invoice' and inv.state == 'draft':
            ${_("Draft Invoice")}
        %elif inv.type == 'out_invoice' and inv.state == 'cancel':
            ${_("Cancelled Invoice")} ${inv.number or ''}
        %elif inv.type == 'out_invoice':
            ${_("Invoice")} ${inv.number or ''}
        %elif inv.type == 'in_invoice':
            ${_("Supplier Invoice")} ${inv.number or ''}
        %elif inv.type == 'out_refund':
            ${_("Refund")} ${inv.number or ''}
        %elif inv.type == 'in_refund':
            ${_("Supplier Refund")} ${inv.number or ''}
        %endif
    </h1>
    <h3  style="clear: both; padding-top: 20px;">
        ${_("Subject : ")} ${inv.name or ''}
    </h3>

    <table class="basic_table" width="100%">
        <tr>
            <th class="date">${_("Invoice Date")}</td>
            <th class="date">${_("Due Date")}</td>
            <!--<th style="text-align:center;width:120px;">${_("Responsible")}</td>-->
            <th style="text-align:center">${_("Payment Term")}</td>
            <th style="text-align:center">${_("Our reference")}</td>
        </tr>
        <tr>
            <td class="date">${formatLang(inv.date_invoice, date=True)}</td>
            <td class="date">${formatLang(inv.date_due, date=True)}</td>
            <!--<td style="text-align:center;width:120px;">${inv.user_id and inv.user_id.name or ''}</td>-->
            <td style="text-align:center">${inv.payment_term and inv.payment_term.note or ''}</td>
            <td style="text-align:center">${inv.origin or ''}</td>
        </tr>
    </table>

    <div>
    %if inv.note1 :
        <p class="std_text"> ${inv.note1 | n} </p>
    %endif
    </div>

    <table class="list_invoice_table" width="100%" style="margin-top: 20px;">
        <thead>
            <tr>
                <th>${_("Description")}</th>
                <th colspan="2">${_("Qty")}</th>
                <!--<th>${_("UoM")}</th>-->
                <th>${_("Unit Price")}</th>
                <!--<th>${_("Taxes")}</th>-->
                <!--<th>${_("Disc.(%)")}</th>-->
                <th>${_("Net Sub Total")}</th>
            </tr>
        </thead>
        <tbody>
        %for line in inv.invoice_line :
            <tr >
                <td>${line.product_id and line.product_id.code or ''} ${line.product_id and line.product_id.name or ''} : ${line.name}</td>
                <td class="amount">${formatLang(line.quantity or 0.0,digits=get_digits(dp='Account'))}</td>
                <td>${line.uos_id and line.uos_id.name or ''}</td>
                <td class="amount">${formatLang(line.price_unit)} ${inv.currency_id.symbol}</td>
                <!--<td style="font-style:italic; font-size: 10;text-align:center;" >${ ', '.join([ tax.description or tax.name for tax in line.invoice_line_tax_id ])}</td>-->
                <!--<td class="amount" width="10%">${line.discount and formatLang(line.discount, digits=get_digits(dp='Account')) or ''} ${line.discount and '%' or ''}</td>-->
                <td class="amount" width="13%">${formatLang(line.price_subtotal, digits=get_digits(dp='Account'))} ${inv.currency_id.symbol}</td>
            </tr>
            %if line.formatted_note:
            <tr>
              <td class="formatted_note" colspan="5">
                ${line.formatted_note| n}
              </td>
            </tr>
            %endif
        %endfor
        </tbody>
        <tfoot class="totals">
            <tr>
                <td colspan="4" style="text-align:right;border-right: thin solid  #ffffff ;border-left: thin solid  #ffffff ;">
                    <b>${_("Net :")}</b>
                </td>
                <td class="amount" style="border-right: thin solid  #ffffff ;border-left: thin solid  #ffffff ;">
                    ${formatLang(inv.amount_untaxed, digits=get_digits(dp='Account'))} ${inv.currency_id.symbol}
                </td>
            </tr>
            <tr class="no_bloc">
                <td colspan="4" style="text-align:right; border-top: thin solid  #ffffff ; border-right: thin solid  #ffffff ;border-left: thin solid  #ffffff ;">
                    <b>${_("Taxes:")}</b>
                </td>
                <td class="amount" style="border-right: thin solid  #ffffff ;border-top: thin solid  #ffffff ;border-left: thin solid  #ffffff ;">
                        ${formatLang(inv.amount_tax, digits=get_digits(dp='Account'))} ${inv.currency_id.symbol}
                </td>
            </tr>
            <tr>
                <td colspan="4" style="border-right: thin solid  #ffffff ;border-top: thin solid  #ffffff ;border-left: thin solid  #ffffff ;border-bottom: thin solid  #ffffff ;text-align:right;">
                    <b>${_("Total:")}</b>
                </td>
                <td class="amount" style="border-right: thin solid  #ffffff ;border-top: thin solid  #ffffff ;border-left: thin solid  #ffffff ;border-bottom: thin solid  #ffffff ;">
                        <b>${formatLang(inv.amount_total, digits=get_digits(dp='Account'))} ${inv.currency_id.symbol}</b>
                </td>
            </tr>
        </tfoot>
    </table>
        <br/>
    <table class="list_total_table" width="60%" >
        <tr>
            <th style="text-align:left;">${_("Rate")}</th>
            <th>${_("Base")}</th>
            <th>${_("Tax")}</th>
        </tr>
        %if inv.tax_line :
        %for t in inv.tax_line :
            <tr>
                <td style="text-align:left;">${ t.name } </td>
                <td class="amount">${ formatLang(t.base, digits=get_digits(dp='Account')) } ${inv.currency_id.symbol}</td>
                <td class="amount">${ formatLang(t.amount, digits=get_digits(dp='Account')) } ${inv.currency_id.symbol}</td>
            </tr>
        %endfor
        %endif
    </table>
        <br/>
        <h4>
                ${_("Thank you for your prompt payment")}
        </h4>
        <br/>
    <%
      inv_bank = inv.partner_bank_id
    %>
    <table class="list_bank_table" >
      <!-- vat value are taken back from commercial id -->
        <tr>
            <th style="width:20%;" colspan="2">${_("Bank")}</th>
            <td style="width:30%;text-align:left;">${inv_bank and inv_bank.bank_name or '-' } </td>
        </tr>
        <tr>
            <th style="width:20%;" colspan="2">${_("IBAN")}</th>
            <td style="width:50%;text-align:left;">${ inv_bank and inv_bank.acc_number or '-' }</td>
        </tr>
        <tr>
            <th width="20%" colspan="2">${_("BIC")}</th>
            <td style="width:30%;">${inv_bank and inv_bank.bank_bic or '-' }</td>
        </tr>
        <tr>
            <th rowspan="4">RIB</th>
            <th>Code banque</th>
            <td>${inv_bank and inv_bank.bank_code or '-' }</td>
        </tr>
        <tr>
            <th>Code agence</th>
            <td>${inv_bank and inv_bank.office or '-' }</td>
        </tr>
        <tr>
            <th>Compte</th>
            <td>${inv_bank and inv_bank.rib_acc_number or '-' }</td>
        </tr>
        <tr>
            <th>Clé</th>
            <td>${inv_bank and inv_bank.key or '-' }</td>
        </tr>
    </table>
    <br/>
    %if inv.comment :
        <p class="std_text">${inv.comment | carriage_returns}</p>
    %endif
    %if inv.note2 :
        <p class="std_text">${inv.note2 | n}</p>
    %endif
    %if inv.fiscal_position :
        <br/>
        <p class="std_text">
        ${inv.fiscal_position.note | n}
        </p>
    %endif
    <!--<p style="page-break-after:always"></p>-->
    %endfor
</body>
</html>
