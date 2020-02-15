// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import DropzoneComponent from "react-dropzone-component";
import "react-dropzone-component/styles/filepicker";
import "dropzone/dist/min/dropzone.min";

const djsConfig = {
  acceptedFiles: "image/jpeg,image/png,image/gif",
  autoProcessQueue: false,
  uploadMultiple: false,
  addRemoveLinks: true
}

const componentConfig = {
  iconFiletypes: [".jpg", ".png", ".gif"],
  showFiletypeIcon: true,
  maxFiles: 1,
  postUrl: "no-url"
}

export default class ImageUploader extends PureComponent {
  showPreview = image => {
    if (image == null) return;

    let mockFile = {
      name: image.name,
      size: image.byte_size,
      dataURL: image.url
    };

    this.myDropzone.files.push(mockFile);
    this.myDropzone.emit("addedfile", mockFile);
    this.myDropzone.createThumbnailFromUrl(
      mockFile,
      this.myDropzone.options.thumbnailWidth,
      this.myDropzone.options.thumbnailHeight,
      this.myDropzone.options.thumbnailMethod,
      true,
      thumbnail => {
        this.myDropzone.emit("thumbnail", mockFile, thumbnail);
        this.myDropzone.emit("complete", mockFile);
      }
    );
  };

  removePrevAndAddNew = image => {
    if (this.myDropzone.files.length > 1) {
      let prevImage = this.myDropzone.files[0];
      this.myDropzone.emit("removedfile", prevImage);
    }

    this.props.selectImage(image);
  };

  render() {
    const { image } = this.props;
    const eventHandlers = {
      init: dropzone => {
        this.myDropzone = dropzone;
        this.showPreview(image);
      },
      addedfile: image => this.removePrevAndAddNew(image),
      removedfile: () => this.props.unselectImage()
    };

    return (
      <DropzoneComponent
        config={componentConfig}
        eventHandlers={eventHandlers}
        djsConfig={djsConfig}
      />
    );
  }
}

ImageUploader.propTypes = {
};

// const Hello = props => (
//   <div>Hello {props.name}!</div>
// )

// Hello.defaultProps = {
//   name: 'David'
// }

// Hello.propTypes = {
//   name: PropTypes.string
// }

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <ImageUploader />,
    document.body.appendChild(document.createElement("div"))
  );
})
