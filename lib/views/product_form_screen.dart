import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/app_drawer.dart';

class ProductFormScreen extends StatefulWidget {
  ProductFormScreen({Key key}) : super(key: key);

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void dispose() {
    super.dispose();
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;
      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;
        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool isValidProtocol = url.toLowerCase().startsWith('http://') ||
        url.toLowerCase().startsWith('https://');
    bool endWhithPng = url.toLowerCase().endsWith('.png');
    bool endWhithJpg = url.toLowerCase().endsWith('.jpg');
    bool endWhithJpeg = url.toLowerCase().endsWith('.jpeg');
    bool endWhithWebp = url.toLowerCase().endsWith('.webp');

    return (isValidProtocol) &&
        (endWhithPng || endWhithJpg || endWhithJpeg || endWhithWebp);
  }

  void _saveForm() {
    //Para ter acesso ao form usa o globalkey
    // _form.currentState.save = Chama o metodo onSave de cada campo do formulario
    bool isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }
    _form.currentState.save();

    final product = Product(
      id: _formData['id'],
      title: _formData['title'],
      description: _formData['description'],
      imageUrl: _formData['imageUrl'],
      price: _formData['price'],
    );

    Products products = Provider.of(context, listen: false);
    if (_formData['id'] == null) {
      products.addProduct(product);
    } else
      products.updateProduct(product);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['title'],
                decoration: InputDecoration(labelText: 'Titulo'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) => _formData['title'] = value,
                validator: (value) {
                  //Se a validação retornar qualquer coisa diferente de nulo vai acusar erro
                  if (value.trim().isEmpty) {
                    return 'Informe um título';
                  }
                  if (value.trim().length < 3) {
                    return 'Informe um título com mais de três caracteres';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['price'].toString(),
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) => _formData['price'] = double.parse(value),
                validator: (value) {
                  bool isEmpty = value.trim().isEmpty;
                  var newValue = double.tryParse(value);
                  bool isValid = newValue == null || newValue <= 0;
                  if (isEmpty || isValid) {
                    return 'Preço inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['description'],
                decoration: InputDecoration(labelText: 'Descrição'),
                focusNode: _descriptionFocusNode,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onSaved: (value) => _formData['description'] = value,
                validator: (value) {
                  return value.trim().isEmpty ? 'Informe a descrição' : null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //Foi colocado o Expanded para definir um tamanho para o campo
                  //senão da uma exceção
                  Expanded(
                    child: TextFormField(
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      decoration: InputDecoration(labelText: 'URL da Imagem'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) => _formData['imageUrl'] = value,
                      validator: (value) {
                        return isValidImageUrl(value)
                            ? null
                            : 'Informe uma URL válida';
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: _imageUrlController.text.isEmpty
                          ? Text(
                              'Informe a url',
                            )
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
